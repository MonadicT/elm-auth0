module Auth
    exposing
        ( PortAuthResponse
        , mapResult
        )

import Msgs


{- | Data type of message received from auth port upon success -}


type alias AuthSuccess =
    { accessToken : String
    , email : String
    , emailVerified : Bool
    , exp : Int
    , name : String
    , nickname : String
    , picture : String
    , sub : String
    }



{- | Data type of message received from auth port upon error -}


type alias PortAuthResponse =
    { err : Maybe String
    , ok : Maybe AuthSuccess
    , stale : Bool
    }

{- | Maps response from the port to Msg -}
mapResult : PortAuthResponse -> Msgs.Msg
mapResult result =
    case ( result.err, result.ok, result.stale ) of
        ( Just msg, _, _ ) ->
            Msgs.Unauthenticated msg

        ( Nothing, _, True ) ->
            Msgs.StaleAuth

        ( Nothing, Just user, False ) ->
            Msgs.Authenticated (toProfile user)

        ( Nothing, Nothing, _ ) ->
            Msgs.Unauthenticated "unknown error in authentication"

{- Maps port response to User Profile -}
toProfile : AuthSuccess -> Msgs.UserProfile
toProfile user =
    Msgs.UserProfile user.email user.emailVerified user.name user.nickname user.picture user.sub
