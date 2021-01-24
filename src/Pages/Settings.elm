module Pages.Settings exposing (Model, Msg, Params, page)

import Api.Data exposing (Data)
import Api.User exposing (User)
import Components.ErrorList
import Html exposing (..)
import Html.Attributes exposing (attribute, class, placeholder, type_, value)
import Html.Events as Events
import Page exposing (Page)
import Ports
import Request exposing (Request)
import Shared
import Utils.Auth exposing (protected)
import Utils.Maybe
import View exposing (View)


page : Shared.Model -> Request Params -> Page Model Msg
page shared _ =
    Page.shared
        { init = init shared
        , update = update
        , subscriptions = subscriptions
        , view = protected view
        }



-- INIT


type alias Params =
    ()


type alias Model =
    { user : Maybe User
    , image : String
    , username : String
    , bio : String
    , email : String
    , password : Maybe String
    , message : Maybe String
    , errors : List String
    }


init : Shared.Model -> ( Model, Cmd Msg, List Shared.Msg )
init shared =
    ( case shared.user of
        Just user ->
            { user = shared.user
            , image = user.image
            , username = user.username
            , bio = user.bio |> Maybe.withDefault ""
            , email = user.email
            , password = Nothing
            , message = Nothing
            , errors = []
            }

        Nothing ->
            { user = shared.user
            , image = ""
            , username = ""
            , bio = ""
            , email = ""
            , password = Nothing
            , message = Nothing
            , errors = []
            }
    , Cmd.none
    , []
    )



-- UPDATE


type Msg
    = Updated Field String
    | SubmittedForm User
    | GotUser (Data User)


type Field
    = Image
    | Username
    | Bio
    | Email
    | Password


update : Msg -> Model -> ( Model, Cmd Msg, List Shared.Msg )
update msg model =
    case msg of
        Updated Image value ->
            ( { model | image = value }, Cmd.none, [] )

        Updated Username value ->
            ( { model | username = value }, Cmd.none, [] )

        Updated Bio value ->
            ( { model | bio = value }, Cmd.none, [] )

        Updated Email value ->
            ( { model | email = value }, Cmd.none, [] )

        Updated Password value ->
            ( { model | password = Just value }, Cmd.none, [] )

        SubmittedForm user ->
            ( { model | message = Nothing, errors = [] }
            , Api.User.update
                { token = user.token
                , user = model
                , onResponse = GotUser
                }
            , []
            )

        GotUser (Api.Data.Success user) ->
            ( { model | message = Just "User updated!" }
            , Ports.saveUser user
            , [ Shared.SignedInUser user ]
            )

        GotUser (Api.Data.Failure reasons) ->
            ( { model | errors = reasons }
            , Cmd.none
            , []
            )

        GotUser _ ->
            ( model, Cmd.none, [] )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- VIEW


view : User -> Model -> View Msg
view user model =
    { title = "Settings"
    , body =
        [ div [ class "settings-page" ]
            [ div [ class "container page" ]
                [ div [ class "row" ]
                    [ div [ class "col-md-6 offset-md-3 col-xs-12" ]
                        [ h1 [ class "text-xs-center" ] [ text "Your Settings" ]
                        , br [] []
                        , Components.ErrorList.view model.errors
                        , Utils.Maybe.view model.message <|
                            \message ->
                                p [ class "text-success" ] [ text message ]
                        , form [ Events.onSubmit (SubmittedForm user) ]
                            [ fieldset []
                                [ fieldset [ class "form-group" ]
                                    [ input
                                        [ class "form-control"
                                        , placeholder "URL of profile picture"
                                        , type_ "text"
                                        , value model.image
                                        , Events.onInput (Updated Image)
                                        ]
                                        []
                                    ]
                                , fieldset [ class "form-group" ]
                                    [ input
                                        [ class "form-control form-control-lg"
                                        , placeholder "Your Username"
                                        , type_ "text"
                                        , value model.username
                                        , Events.onInput (Updated Username)
                                        ]
                                        []
                                    ]
                                , fieldset [ class "form-group" ]
                                    [ textarea
                                        [ class "form-control form-control-lg"
                                        , placeholder "Short bio about you"
                                        , attribute "rows" "8"
                                        , value model.bio
                                        , Events.onInput (Updated Bio)
                                        ]
                                        []
                                    ]
                                , fieldset [ class "form-group" ]
                                    [ input
                                        [ class "form-control form-control-lg"
                                        , placeholder "Email"
                                        , type_ "text"
                                        , value model.email
                                        , Events.onInput (Updated Email)
                                        ]
                                        []
                                    ]
                                , fieldset [ class "form-group" ]
                                    [ input
                                        [ class "form-control form-control-lg"
                                        , placeholder "Password"
                                        , type_ "password"
                                        , value (Maybe.withDefault "" model.password)
                                        , Events.onInput (Updated Password)
                                        ]
                                        []
                                    ]
                                , button [ class "btn btn-lg btn-primary pull-xs-right" ] [ text "Update Settings" ]
                                ]
                            ]
                        ]
                    ]
                ]
            ]
        ]
    }
