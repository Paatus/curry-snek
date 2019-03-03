{-# LANGUAGE OverloadedStrings #-}
module Start where

import Web.Scotty
import Data.Aeson
import Data.Text.Lazy

import Control.Monad.Trans

data StartRequest = StartRequest { game_id :: Int
                                 , width   :: Int
                                 , height  :: Int}

instance FromJSON StartRequest where
  parseJSON (Object v) = 
    StartRequest <$> v .: "game_id"
                 <*> v .: "width"
                 <*> v .: "height"

data StartResponse = StartResponse { color :: !String
                                   , secondary_color :: !String
--                                 , head_url :: !String
                                   , taunt :: !String
                                   , head_type :: !String
                                   , tail_type :: !String}
-- | head types = bendr, dead, fang, pixel, regular, safe, sand-worm,
--                shades, smile, tongue

-- | tail types = block-bum, curled, fat-rattle, freckled, pixel,
--                regular, round-bum, skinny, small-rattle

instance ToJSON StartResponse where
  toJSON (StartResponse color secondary_color {-head_url-}
                        taunt head_type       tail_type) =
    object ["color" .= color
          , "secondary_color" .= secondary_color
          {-, "head_url" .= head_url-}
          , "taunt" .= taunt
          , "head_type" .= head_type
          , "tail_type" .= tail_type]

postStart :: StartResponse -> ActionM ()
postStart sr = do
  liftIO $ putStrLn "attempting json parse"
  req <- jsonData :: ActionM StartRequest
  liftIO $ putStrLn "successful parse"
  Web.Scotty.json sr
  return ()
