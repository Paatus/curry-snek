{-# LANGUAGE OverloadedStrings #-}
{-# OPTIONS_GHC -Wno-incomplete-patterns #-}
module GameState where

import Web.Scotty
import Data.Aeson
import Data.Text.Lazy hiding (map, head, filter, zipWith, repeat, init)
import Data.List
import Data.Maybe
import Data.Aeson.Types (emptyObject)
import Data.ByteString.Lazy (ByteString)

import Start

import Control.Monad.Trans

data GameState = GameState
    { game :: Game
    , turn :: Int
    , board :: Board
    , you :: Snake
    } deriving (Show)

data Board = Board
    { height :: Int
    , width :: Int
    , food :: [Pos]
    , hazards :: [Pos]
    , snakes :: [Snake]
    } deriving (Show)

data Pos = Pos
    { x :: Int
    , y :: Int
    } deriving (Show, Eq)

data Snake = Snake
    { snakeId :: Text
    , name :: Text
    , health :: Int
    , body :: [Pos]
    , latency :: Text
    , head :: Pos
    , length :: Int
    , shout :: Text
    , squad :: Text
    } deriving (Show, Eq)

data Game = Game
    { gameIDGame :: Text
    , rulesetGame :: Ruleset
    , timeoutGame :: Int
    } deriving (Show)

data Ruleset = Ruleset
    { nameRuleset :: Text
    , versionRuleset :: Text
    } deriving (Show)

decodeTopLevel :: ByteString -> Maybe GameState
decodeTopLevel = decode

encodeTopLevel :: GameState -> ByteString
encodeTopLevel = encode

instance ToJSON GameState where
    toJSON (GameState gameWelcome turnWelcome boardWelcome youWelcome) =
        object
        [ "game" .= gameWelcome
        , "turn" .= turnWelcome
        , "board" .= boardWelcome
        , "you" .= youWelcome
        ]

instance FromJSON GameState where
    parseJSON (Object v) = GameState
        <$> v .: "game"
        <*> v .: "turn"
        <*> v .: "board"
        <*> v .: "you"

instance ToJSON Board where
    toJSON (Board heightBoard widthBoard foodBoard hazardsBoard snakesBoard) =
        object
        [ "height" .= heightBoard
        , "width" .= widthBoard
        , "food" .= foodBoard
        , "hazards" .= hazardsBoard
        , "snakes" .= snakesBoard
        ]

instance FromJSON Board where
    parseJSON (Object v) = Board
        <$> v .: "height"
        <*> v .: "width"
        <*> v .: "food"
        <*> v .: "hazards"
        <*> v .: "snakes"

instance ToJSON Pos where
    toJSON (Pos x y) =
        object
        [ "x" .= x
        , "y" .= y
        ]

instance FromJSON Pos where
    parseJSON (Object v) = Pos
        <$> v .: "x"
        <*> v .: "y"

instance ToJSON Snake where
    toJSON (Snake youIDYou nameYou healthYou bodyYou latencyYou headYou lengthYou shoutYou squadYou) =
        object
        [ "id" .= youIDYou
        , "name" .= nameYou
        , "health" .= healthYou
        , "body" .= bodyYou
        , "latency" .= latencyYou
        , "head" .= headYou
        , "length" .= lengthYou
        , "shout" .= shoutYou
        , "squad" .= squadYou
        ]

instance FromJSON Snake where
    parseJSON (Object v) = Snake
        <$> v .: "id"
        <*> v .: "name"
        <*> v .: "health"
        <*> v .: "body"
        <*> v .: "latency"
        <*> v .: "head"
        <*> v .: "length"
        <*> v .: "shout"
        <*> v .: "squad"

instance ToJSON Game where
    toJSON (Game gameIDGame rulesetGame timeoutGame) =
        object
        [ "id" .= gameIDGame
        , "ruleset" .= rulesetGame
        , "timeout" .= timeoutGame
        ]

instance FromJSON Game where
    parseJSON (Object v) = Game
        <$> v .: "id"
        <*> v .: "ruleset"
        <*> v .: "timeout"

instance ToJSON Ruleset where
    toJSON (Ruleset nameRuleset versionRuleset) =
        object
        [ "name" .= nameRuleset
        , "version" .= versionRuleset
        ]

instance FromJSON Ruleset where
    parseJSON (Object v) = Ruleset
        <$> v .: "name"
        <*> v .: "version"
