{-# LANGUAGE OverloadedStrings #-}
module Move where

import Web.Scotty
import Data.Aeson
import Data.Text.Lazy hiding (map, head, filter, zipWith, repeat, init)
import Data.List
import Data.Maybe

import Start

import Control.Monad.Trans

data Pos = Pos { posobject :: !String
               , x         :: Int
               , y         :: Int}
               deriving Show

instance FromJSON Pos where
  parseJSON (Object v) =
    Pos <$> v .: "object"
        <*> v .: "x"
        <*> v .: "y"

data Food = Food { foodinfo   :: [Pos],
                   foodobject :: !String}
                   deriving Show

instance FromJSON Food where
  parseJSON (Object v) =
      Food <$> (v .: "data" >>= mapM parseJSON)
           <*>  v .: "object"

data Snake = Snake { body        :: [Pos]
                   , health      :: Int
                   , id          :: !String
                   , name        :: !String
                   , snakeobject :: !String}
           --      , snaketaunt  :: !String } -- does not work properly
                   deriving Show

instance FromJSON Snake where
  parseJSON (Object v) =
    Snake <$> (v .: "body" >>= (.: "data") >>= mapM parseJSON)
          <*>  v .: "health"
          <*>  v .: "id"
          <*>  v .: "name"
          <*>  v .: "object"
       -- <*>  v .: "taunt" -- does not work properly

data GameState = GameState { food     :: Food
                           , height   :: Int
                           , width    :: Int
                           , turn     :: Int
                           , gid      :: Int
                           , gsobject :: !String
                           , snakes   :: [Snake]
                           , you      :: Snake}
                           deriving Show

instance FromJSON GameState where
  parseJSON (Object v) =
    GameState <$>  v .: "food"
              <*>  v .: "height"
              <*>  v .: "width"
              <*>  v .: "turn"
              <*>  v .: "id"
              <*>  v .: "object"
              <*> (v .: "snakes" >>= (.: "data") >>= mapM parseJSON)
              <*>  v .: "you"

data MoveResponse = MoveResponse { move :: Action }

instance ToJSON MoveResponse where
  toJSON (MoveResponse move) = object [ "move" .= move ]

data Action = U | D | L | R deriving Eq

instance ToJSON Action where
  toJSON U = String "up"
  toJSON D = String "down"
  toJSON L = String "left"
  toJSON R = String "right"

-- TODO: Remove and implement better handling of exceptions in jsonData
emptyGs = GameState (Food [] "") 0 0 0 0 "gsobj" [] (Snake [] 0 "" "" "")

postMove :: ActionM ()
postMove = do
  gs <- jsonData `rescue` (\ass -> do liftIO (print ass); return emptyGs;)
  -- liftIO $ putStrLn (show gs) -- Uncomment to print received GameState
  let m = compute_move gs
  Web.Scotty.json (MoveResponse m)

------------------------------------------------------------------------------
{- SNAKE LOGIC BELOW -}

type Position = (Int, Int) -- (x, y)
posToPosition (Pos _ x y) = (x,y)

-- | Input:  GameState
--   Output: List of coordinate occupied by apples
getfood :: GameState -> [Position]
getfood gs = (map (\p -> (x p, y p)) . foodinfo . food) gs

type Snek = (Position, [Position], Int, String) -- (head, body, health, id)

-- | Input:  GameState
--   Output: A Snek representing your snake
getyou :: GameState -> Snek
getyou gs = (posToPosition (head body), map posToPosition body, health, sid)
  where (Snake body health sid _ _) = you gs

-- | Input:  GameState
--   Output: A list of Snek, representing all other snakes (not including yours)
getsnakes :: GameState -> [Snek]
getsnakes gs = filter (\(_,_,_,s1) -> let (_,_,_,s2) = getyou gs
                                      in  s1 == s2) 
               $ map snaketosnek (snakes gs)
  where snaketosnek (Snake body health sid _ _ ) =
          (posToPosition (head body),map posToPosition body, health, sid)

compute_move :: GameState -> Action
compute_move gs@(GameState food height width turn gid gsobject snakes you) = U
