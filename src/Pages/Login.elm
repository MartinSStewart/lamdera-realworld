module Pages.Login exposing (Model, Msg, Params, page)

import Api.Data exposing (Data)
import Api.User exposing (User)
import Components.UserForm
import Gen.Route as Route
import Html exposing (..)
import Page exposing (Page)
import Request exposing (Request)
import Shared
import Utils.Route
import View exposing (View)


page : Shared.Model -> Request Params -> Page Model Msg
page shared req =
    Page.shared
        { init = init shared
        , update = update req
        , subscriptions = subscriptions
        , view = view
        }



-- INIT


type alias Params =
    ()


type alias Model =
    { user : Data User
    , email : String
    , password : String
    }


init : Shared.Model -> ( Model, Cmd Msg, List Shared.Msg )
init shared =
    ( Model
        (case shared.user of
            Just user ->
                Api.Data.Success user

            Nothing ->
                Api.Data.NotAsked
        )
        ""
        ""
    , Cmd.none
    , []
    )



-- UPDATE


type Msg
    = Updated Field String
    | AttemptedSignIn
    | GotUser (Data User)


type Field
    = Email
    | Password


update : Request Params -> Msg -> Model -> ( Model, Cmd Msg, List Shared.Msg )
update req msg model =
    case msg of
        Updated Email email ->
            ( { model | email = email }
            , Cmd.none
            , []
            )

        Updated Password password ->
            ( { model | password = password }
            , Cmd.none
            , []
            )

        AttemptedSignIn ->
            ( model
            , Api.User.authentication
                { user =
                    { email = model.email
                    , password = model.password
                    }
                , onResponse = GotUser
                }
            , []
            )

        GotUser user ->
            case Api.Data.toMaybe user of
                Just user_ ->
                    ( { model | user = user }
                    , Utils.Route.navigate req.key Route.Home_
                    , [ Shared.SignedInUser user_ ]
                    )

                Nothing ->
                    ( { model | user = user }
                    , Cmd.none
                    , []
                    )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- VIEW


view : Model -> View Msg
view model =
    { title = "Sign in"
    , body =
        [ Components.UserForm.view
            { user = model.user
            , label = "Sign in"
            , onFormSubmit = AttemptedSignIn
            , alternateLink = { label = "Need an account?", route = Route.Register }
            , fields =
                [ { label = "Email"
                  , type_ = "email"
                  , value = model.email
                  , onInput = Updated Email
                  }
                , { label = "Password"
                  , type_ = "password"
                  , value = model.password
                  , onInput = Updated Password
                  }
                ]
            }
        ]
    }
