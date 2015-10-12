module Handler.Home where

import Import
import Yesod.Form.Bootstrap3 (BootstrapFormLayout (..), renderBootstrap3,
                              withSmallInput)
import           Yesod.Form.Jquery
import           Data.Time           (Day)

data AreaPriceTrendQuery = AreaPriceTrendQuery
    {  postcodePrefix  :: Text
    ,  startDate :: Day
    ,  endDate :: Day
    }
    deriving Show

data AreaPriceTrend = AreaPriceTrend
    {  query :: AreaPriceTrendQuery
    ,  avPriceStart :: Int
    ,  avPriceEnd :: Int
    ,  dataStart :: Date
    ,  dataEnd :: Date
    ,  interval :: NominalDiffTime
    ,  timeSeries :: [Int]
    }

instance YesodJquery App

-- This is a handler function for the GET request method on the HomeR
-- resource pattern. All of your resource patterns are defined in
-- config/routes
--
-- The majority of the code you will write in Yesod lives in these handler
-- functions. You can spread them across multiple files if you are so
-- inclined, or create a single monolithic file.
getHomeR :: Handler Html
getHomeR = do
    (formWidget, formEnctype) <- generateFormPost sampleForm
    let submission = Nothing :: Maybe AreaPriceTrendQuery
        handlerName = "getHomeR" :: Text
    defaultLayout $ do
        aDomId <- newIdent
        setTitle "House Price Trends UK"
        $(widgetFile "homepage")

postHomeR :: Handler Html
postHomeR = do
    ((result, formWidget), formEnctype) <- runFormPost sampleForm
    let handlerName = "postHomeR" :: Text
        submission = case result of
            FormSuccess res -> Just res
            _ -> Nothing
        areaPriceData = lookupPriceData submission
    defaultLayout $ do
        aDomId <- newIdent
        setTitle "House Price Trends UK"
        $(widgetFile "homepage")

sampleForm :: Form AreaPriceTrendQuery
sampleForm = renderBootstrap3 BootstrapBasicForm $ AreaPriceTrendQuery
    <$> areq textField (withSmallInput "Postcode Prefix") Nothing
    <*> areq (jqueryDayField def
        { jdsChangeYear = True -- give a year dropdown
        , jdsYearRange = "1995:-1" -- 1995 till last year
        }) "Start Date" Nothing
    <*> areq (jqueryDayField def
        { jdsChangeYear = True -- give a year dropdown
        , jdsYearRange = "1995:-1" -- 1995 till last year
        }) "End Date" Nothing
