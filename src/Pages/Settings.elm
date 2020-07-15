module Pages.Settings exposing (Model, Msg, Params, page)

import Html exposing (..)
import Html.Attributes exposing (attribute, class, placeholder, type_)
import Shared
import Spa.Document exposing (Document)
import Spa.Page as Page exposing (Page)
import Spa.Url exposing (Url)


page : Page Params Model Msg
page =
    Page.application
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        , save = save
        , load = load
        }



-- INIT


type alias Params =
    ()


type alias Model =
    {}


init : Shared.Model -> Url Params -> ( Model, Cmd Msg )
init shared { params } =
    ( {}, Cmd.none )



-- UPDATE


type Msg
    = ReplaceMe


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ReplaceMe ->
            ( model, Cmd.none )


save : Model -> Shared.Model -> Shared.Model
save model shared =
    shared


load : Shared.Model -> Model -> ( Model, Cmd Msg )
load shared model =
    ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> Document Msg
view model =
    { title = "Settings"
    , body =
        [ div [ class "settings-page" ]
            [ div [ class "container page" ]
                [ div [ class "row" ]
                    [ div [ class "col-md-6 offset-md-3 col-xs-12" ]
                        [ h1 [ class "text-xs-center" ]
                            [ text "Your Settings" ]
                        , form []
                            [ fieldset []
                                [ fieldset [ class "form-group" ]
                                    [ input [ class "form-control", placeholder "URL of profile picture", type_ "text" ]
                                        []
                                    ]
                                , fieldset [ class "form-group" ]
                                    [ input [ class "form-control form-control-lg", placeholder "Your Name", type_ "text" ]
                                        []
                                    ]
                                , fieldset [ class "form-group" ]
                                    [ textarea [ class "form-control form-control-lg", placeholder "Short bio about you", attribute "rows" "8" ]
                                        []
                                    ]
                                , fieldset [ class "form-group" ]
                                    [ input [ class "form-control form-control-lg", placeholder "Email", type_ "text" ]
                                        []
                                    ]
                                , fieldset [ class "form-group" ]
                                    [ input [ class "form-control form-control-lg", placeholder "Password", type_ "password" ]
                                        []
                                    ]
                                , button [ class "btn btn-lg btn-primary pull-xs-right" ]
                                    [ text "Update Settings              " ]
                                ]
                            ]
                        ]
                    ]
                ]
            ]
        ]
    }
