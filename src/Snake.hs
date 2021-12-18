{-# LANGUAGE OverloadedStrings #-}

module Snake where

import Web.Scotty
import Control.Monad.Trans
import Data.Aeson
import Network.HTTP.Types.Status
import Control.Monad

import System.Environment
import Data.Maybe
import Text.Read hiding (get)

import Info
import Move
import End

-- See Start.hs for different snake configuration options.
-- Not super important, but perhaps it is nice to change the color.
snakeConfig :: InfoResponse
snakeConfig = InfoResponse "1"             -- apiversion
                           "Paatus"        -- author
                           "#641E16"       -- color
                           "pixel"         -- head
                           "pixel"         -- tail
                           "0.0.1"         -- version

ex = do
  inp <- liftIO $ lookupEnv "PORT"
  let port = read (fromMaybe "8080" inp) :: Int
  scotty port $ do
    get "/" $ Web.Scotty.json snakeConfig
    post "/move" postMove
    post "/end" postEnd

