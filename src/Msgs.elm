-- Copyright (c) 2018 Praki Prakash, All rights reserved.

module Msgs exposing (..)

type Msg
    = Authenticated UserProfile
    | Unauthenticated String
    | StaleAuth
    | LoginRequest
    | LogOutRequest

type alias UserProfile =
    { email : String
    , email_verified : Bool
    , name : String
    , nickname : String
    , picture : String
    , user_id : String
    }
