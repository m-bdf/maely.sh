module Main exposing (main)

import Browser
import Dict
import Element exposing (..)
import Element.Background as Background
import Element.Font as Font
import FeatherIcons as Icons
import Html
import Html.Attributes as Attrs
import Http
import Markdown



--- MAIN


main =
    Browser.document
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }


init () =
    ( { sections = Dict.empty }
    , Cmd.batch <|
        List.map fetchSection sections
    )


type Msg
    = GotSection String (Result Http.Error String)


update msg model =
    case msg of
        GotSection name result ->
            case result of
                Ok section ->
                    ( { model
                        | sections = Dict.insert name section model.sections
                      }
                    , Cmd.none
                    )

                Err _ ->
                    ( model, Cmd.none )



--- SECTIONS


sections =
    [ "intro"
    , "education"
    , "skills"
    , "languages"
    , "experience"
    , "interests"
    ]


fetchSection name =
    Http.get
        { url = "sections/" ++ name ++ ".md"
        , expect = Http.expectString (GotSection name)
        }


getSection name model =
    let
        mdToHtml =
            Markdown.toHtmlWith
                { githubFlavored =
                    Just
                        { tables = False
                        , breaks = True
                        }
                , defaultHighlighting = Nothing
                , sanitize = False
                , smartypants = True
                }
    in
    paragraph
        [ paddingEach
            { top = 10
            , right = 0
            , bottom = 10
            , left = 25
            }
        ]
        [ Dict.get name model.sections
            |> Maybe.withDefault ""
            |> mdToHtml []
            |> html
        ]


sectionDivider =
    el
        [ width fill
        , padding 25
        ]
    <|
        el
            [ width fill
            , height (px 2)
            , Background.color (rgb255 0xDE 0xAF 0xFF)
            ]
            none



--- VIEW


view model =
    { title = "Maëlys Bras de fer"
    , body =
        [ Html.node "meta"
            [ Attrs.name "viewport"
            , Attrs.attribute "content"
                "width=device-width, initial-scale=1"
            ]
            []
        , layout
            [ Font.family
                [ Font.external
                    { name = "Montserrat"
                    , url =
                        "https://fonts.googleapis.com/css2"
                            ++ "?family=Montserrat:wght@500&display=swap"
                    }
                , Font.typeface "Verdana"
                , Font.sansSerif
                ]
            ]
          <|
            body model
        ]
    }


body model =
    column
        [ width (minimum 800 fill)
        , height fill
        , spacing -25
        , Font.size 13
        ]
        [ intro model
        , contactRow
        , details model
        , el
            [ alignRight
            , alignBottom
            , padding 10
            , Font.size 10
            , Font.italic
            ]
          <|
            text "Made with Nix and Elm"
        ]


intro model =
    row
        [ width fill
        , paddingEach
            { top = 25
            , right = 0
            , bottom = 10
            , left = 50
            }
        ]
        [ row
            [ width (fillPortion 10)
            , padding 25
            , Font.color (rgb255 0xFF 0xFF 0xFF)
            , Background.color (rgb255 0x33 0x33 0x33)
            ]
            [ getSection "intro" model
            , iconColumn
            ]
        , el
            [ width fill
            , height fill
            , Background.color (rgb255 0xDE 0xAF 0xFF)
            ]
            none
        ]


iconColumn =
    let
        iconLink name icon url =
            link []
                { url = "https://" ++ name ++ ".com/" ++ url
                , label =
                    column [ spacing 5 ]
                        [ el [ centerX ] <|
                            html (Icons.toHtml [] icon)
                        , text url
                        ]
                }
    in
    column
        [ height fill
        , spacing 25
        ]
        [ iconLink "linkedin" Icons.linkedin "in/bdf"
        , iconLink "github" Icons.github "m-bdf"
        , image
            [ alignBottom
            , width fill
            ]
            { src =
                "https://raw.githubusercontent.com"
                    ++ "/NixOS/nixos-artwork/master/logo/white.svg"
            , description = "NixOS"
            }
        ]


contactRow =
    let
        contactEl icon txt =
            row [ spacing 10 ]
                [ el [] <|
                    html (Icons.toHtml [] icon)
                , text txt
                ]
    in
    row
        [ paddingEach
            { top = 10
            , right = 25
            , bottom = 10
            , left = 75
            }
        , spacing 25
        , Background.color (rgb255 0xDE 0xAF 0xFF)
        ]
        [ contactEl Icons.mapPin "Villeurbanne, France"
        , contactEl Icons.mail "contact@maely.sh"
        ]


details model =
    row
        [ width fill
        , paddingEach
            { top = 50
            , right = 25
            , bottom = 25
            , left = 25
            }
        ]
        [ column [ width (fillPortion 10) ]
            [ getSection "education" model
            , sectionDivider
            , getSection "skills" model
            , sectionDivider
            , getSection "languages" model
            ]
        , column [ width (fillPortion 25) ]
            [ getSection "experience" model
            , sectionDivider
            , getSection "interests" model
            ]
        ]
