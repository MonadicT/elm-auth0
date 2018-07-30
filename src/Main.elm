module Main exposing (main)

import Html exposing (program)
import Bootstrap.Button as Button
import Html exposing (Html, div, text, img, p, h2, a)
import Html.Attributes exposing (href, src)
import Html.Events exposing (onClick)
import Auth
import Msgs exposing (Msg(..))
import Ports


-- | Data types


type Page
    = HomePage
    | LogoutPage



--| User profile data type


type alias UserProfile =
    { email : String
    , email_verified : Bool
    , name : String
    , nickname : String
    , picture : String
    , user_id : String
    }



-- | Model


type alias Model =
    { authenticated : Bool
    , profile : Maybe UserProfile
    , errorMsg : String
    }



-- | View functions


view : Model -> Html Msg
view model =
    if model.authenticated then
        welcomePage model
    else
        loginPage



--| View when authenticated


welcomePage : Model -> Html Msg
welcomePage model =
    case model.profile of
        Just profile ->
            div []
                [ h2 [] [ text ("Hello, " ++ profile.name ++ "!") ]
                , img [ src profile.picture ] []
                , p [] [ text profile.email ]
                , p [] [ text profile.nickname ]
                , p [] [ text ("Auth0 user id: " ++ profile.user_id) ]
                , Button.button [ Button.onClick LogOutRequest, Button.primary ]
                    [ text "Logout" ]
                ]

        Nothing ->
            div [] [ text "I shouldn't be called unless model.profile is available!" ]



--! View with prompt to login again


loginPage : Html Msg
loginPage =
    div []
        [ p [] [ text "You have logged out!" ]
        , a [ href "/" ] [ text "Login" ]
        ]


{-| Subscription handling
-}
subscriptions : Model -> Sub Msg
subscriptions model =
    Ports.authResponse Auth.mapResult



{- | Update function -}


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Unauthenticated err ->
            ( { model | authenticated = False }, Cmd.none )

        StaleAuth ->
            ( model, Ports.authRequest () )

        Authenticated profile ->
            ( { model
                | profile = Just profile
                , authenticated = True
              }
            , Cmd.none
            )

        LoginRequest ->
            ( model, Ports.authRequest () )

        LogOutRequest ->
            ( { model | authenticated = False }, Ports.authClear () )


initialModel : ( Model, Cmd Msg )
initialModel =
    ( { authenticated = False
      , profile = Nothing
      , errorMsg = ""
      }
    , Ports.authStatus ()
    )


main : Program Never Model Msg
main =
    program
        { init = initialModel
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
