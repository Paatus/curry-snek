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

run = do
  inp <- liftIO $ lookupEnv "PORT"
  let port = read (fromMaybe "8080" inp) :: Int
  scotty port $ do
    get "/" getInfo
    post "/move" postMove
    post "/end" postEnd

