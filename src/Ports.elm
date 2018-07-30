-- Copyright (c) 2018 Praki Prakash, All rights reserved.


port module Ports exposing (..)

import Auth exposing (PortAuthResponse)


port authStatus : () -> Cmd msg


port authRequest : () -> Cmd msg


port authResponse : (PortAuthResponse -> msg) -> Sub msg


port authClear : () -> Cmd msg
