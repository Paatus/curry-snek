{-# LANGUAGE OverloadedStrings #-}
{-# OPTIONS_GHC -Wno-incomplete-patterns #-}
module Info where

import Web.Scotty
import Data.Aeson
import Data.Text.Lazy

import Control.Monad.Trans
import GameState (GameState(GameState))

data InfoResponse = InfoResponse { apiversion :: !String
                                   , author :: !String
                                   , color :: !String
                                   , head :: !String
                                   , tail :: !String
                                   , version :: !String}


instance ToJSON InfoResponse where
  toJSON (InfoResponse apiversion author color head tail version) =
    object ["apiversion" .= apiversion
          , "author" .= author
          , "color" .= color
          , "head" .= head
          , "tail" .= tail
          , "version" .= version
        ]

snakeConfig :: InfoResponse
snakeConfig = InfoResponse "1"             -- apiversion
                           "Paatus"        -- author
                           "#641E16"       -- color
                           "pixel"         -- head
                           "pixel"         -- tail
                           "0.0.1"         -- version

getInfo :: ActionM ()
getInfo = Web.Scotty.json snakeConfig
