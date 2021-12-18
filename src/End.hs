{-# LANGUAGE OverloadedStrings #-}
module End where

import Web.Scotty
import Data.Aeson
import Data.Text.Lazy

import Control.Monad.Trans
import Network.HTTP.Types.Status

postEnd :: ActionM ()
postEnd = do
  -- parse and check request here
  status (Status 200 "")
  return ()
