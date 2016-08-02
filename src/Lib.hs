{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE DeriveGeneric #-}

module Lib
    ( startServer
    ) where

--import Data.Text
import Data.List (isInfixOf)
import Data.Char (toLower)
import Servant
import Data.Aeson
import Network.Wai
import Network.Wai.Handler.Warp
import Data.Time.Calendar
import GHC.Generics

type Speaker = String

data Event = Event
  { title :: String
  , speakers :: [Speaker]
  , day :: Day
  } deriving (Eq, Show, Generic)

instance ToJSON Event

geeknights :: [Event]
geeknights =
  [ Event "Artificial Intelligence and Machine Learning" ["Anup Vasudevan"] (fromGregorian 2016 08 3)
  , Event "Evolution of Programming Languages" ["Jonnalagadda Srinivas"] (fromGregorian 2015 07 6)
  ]

type EventAPI = "events" :> Get '[JSON] [Event]
  :<|> "event" :> Capture "id" Int :> Get '[JSON] Event

server :: Server EventAPI
server = listEvents :<|> readEvent
  where
    listEvents = return geeknights
    readEvent id = return (geeknights !! (id - 1))

eventAPI :: Proxy EventAPI
eventAPI = Proxy

app :: Application
app = serve eventAPI server

startServer :: IO ()
startServer= do
  putStrLn "Running at http://localhost:8080"
  run 8080 app
