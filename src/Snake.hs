{-# LANGUAGE OverloadedStrings #-}

module Snake where

import Web.Scotty
import Control.Monad.Trans

ex = scotty 8080 $
  get "/:word" $ do
