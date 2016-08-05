{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ScopedTypeVariables #-}

module Lib (startServer) where 

import Data.Text (Text)
import Data.List (isInfixOf)
import Data.Char (toLower)
import Servant
import Data.Aeson
import Network.Wai
import Network.Wai.Handler.Warp hiding (Connection)
import Data.Time.Calendar
import GHC.Generics
import Database.PostgreSQL.Simple
import Database.PostgreSQL.Simple.FromRow
import Database.PostgreSQL.Simple.ToField
import Database.PostgreSQL.Simple.ToRow
import Control.Applicative
import Control.Monad.IO.Class (liftIO)
import Data.Char (toLower)

data Event = Event
  { eventId :: Integer
  , eventTitle :: Text
  , eventSpeaker :: Text
  , eventDate :: Day
  } deriving (Eq, Show, Generic)

instance ToJSON Event
instance FromJSON Event

instance FromRow Event where
  fromRow = Event <$> field <*> field <*> field <*> field

instance ToRow Event where
  toRow event = [ toField (eventId event)
                , toField (eventTitle event)
                , toField (eventSpeaker event)
                , toField (eventDate event)]

type EventAPI = "events" :> Get '[JSON] [Event]
  :<|> "event" :> Capture "id" Int :> Get '[JSON] Event
  :<|> "events" :> "search" :> Capture "name" String :> Get '[JSON] [Event]

server :: Connection -> Server EventAPI
server conn = listEvents :<|> readEvent :<|> searchEvents
  where
    listEvents = liftIO $ query_ conn "SELECT * FROM events"
    readEvent id = do
      events <- liftIO $ query conn "SELECT * FROM events WHERE id = ?" (Only id)
      return $ head events
    searchEvents q = liftIO $ query conn "SELECT * FROM events WHERE LOWER(title) LIKE ?" (Only qu)
      where qu :: String = "%" ++ (map toLower q) ++ "%"

eventAPI :: Proxy EventAPI
eventAPI = Proxy

startServer :: IO ()
startServer= do
  putStrLn "Running at http://localhost:8080"
  conn <- connectPostgreSQL "host=localhost user=eu dbname=eu"
  run 8080 . serve eventAPI $ server conn
