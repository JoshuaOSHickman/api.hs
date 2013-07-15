{-# LANGUAGE OverloadedStrings, ExistentialQuantification #-}
module Web.Api where

import Control.Monad
import Control.Monad.IO.Class (liftIO)
import Data.Map (Map)
import Data.Map as Map
import qualified Data.ByteString.Lazy.Char8 as L

import Data.Aeson

import Happstack.Server

data ApiFunction = forall a b. (FromJSON a, ToJSON b) => ApiFunction (a -> IO b)
callApi :: (FromJSON a) => ApiFunction -> a -> IO String
callApi (ApiFunction f) input = do 
  out <- f input
  return . L.unpack . encode $ (out :: a)

myPolicy :: BodyPolicy
myPolicy = defaultBodyPolicy "/tmp/" (1024 * 100) 10000 1000

-- Grabbed from http://stackoverflow.com/questions/8865793/how-to-create-json-rest-api-with-happstack-json-body
getBody :: ServerPart L.ByteString
getBody = do
  req  <- askRq 
  body <- liftIO $ takeRequestBody req 
  case body of 
    Just rqbody -> return . unBody $ rqbody 
    Nothing     -> return "" 

happstackServerPart :: String -> ApiFunction -> ServerPart Response
happstackServerPart location func = dir location $ do 
  method POST
  decodeBody myPolicy
  body <- getBody
  let arg = decode body
  case arg of
    Just input ->
      ok . liftIO $ toResponse $ callApi func input


happstack :: Map String ApiFunction -> ServerPart Response
happstack serverspec = msum $ Prelude.map (\(path, func) -> happstackServerPart path func) (Map.assocs serverspec)

runapi :: Map String ApiFunction -> IO ()
runapi = undefined
