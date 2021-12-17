{-# LANGUAGE OverloadedStrings #-}
module Move where

import GameState
import Web.Scotty
import Data.Aeson
import Data.Text.Lazy hiding (map, head, filter, zipWith, repeat, init)
import Data.List
import Data.Maybe
import Data.Aeson.Types (emptyObject)
import Data.ByteString.Lazy (ByteString)

import Start

import Control.Monad.Trans

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
emptyGameState :: GameState
emptyGameState = GameState emptyGame 1 emptyBoard emptyYou

emptyBoard :: Board
emptyBoard = Board 11 11 [] [] []

emptyRuleSet :: Ruleset
emptyRuleSet = Ruleset "" ""

emptyGame :: Game
emptyGame = Game "" emptyRuleSet 1

emptyYou :: Snake
emptyYou = Snake "" "" 100 [] "" (Pos 0 0) 1 "" ""

postMove :: ActionM ()
postMove = do
  gs <- jsonData `rescue` (\ass -> do liftIO (print ass); return emptyGameState;)
  -- liftIO $ putStrLn (show gs) -- Uncomment to print received GameState
  let m = computeMove gs
  Web.Scotty.json (MoveResponse m)

------------------------------------------------------------------------------
{- SNAKE LOGIC BELOW -}

type Position = (Int, Int) -- (x, y)
posToPosition (Pos x y) = (x,y)

-- | Input:  GameState
--   Output: List of coordinate occupied by apples
getfood :: GameState -> [Position]
getfood gs = map posToPosition $ food (board gs)


-- | Input:  GameState
--   Output: A Snek representing your snake
getyou :: GameState -> Snake
getyou = GameState.you

-- | Input:  GameState
--   Output: A list of Snek, representing all other snakes (not including yours)
getsnakes :: GameState -> [Snake]
getsnakes gs = filter (/= getyou gs) $ snakes (board gs)

computeMove :: GameState -> Action
computeMove gs@(GameState game turn board you) = U
