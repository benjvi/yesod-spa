module Handler.Ben where

import Import
import Yesod.Form.Bootstrap3 (BootstrapFormLayout (..), renderBootstrap3,
                              withSmallInput)

getBenR :: Handler Html
getBenR = do
    (formWidget, formEnctype) <- generateFormPost sampleForm
    let submission = Nothing :: Maybe (FileInfo, Text)
        handlerName = "getBenR" :: Text
    defaultLayout $ do
        aDomId <- newIdent
        setTitle "Welcome To Yesod!"
        $(widgetFile "benpage")

sampleForm :: Form Text
sampleForm = renderBootstrap3 BootstrapBasicForm $ areq textField (withSmallInput "Postcode Prefix:") Nothing

