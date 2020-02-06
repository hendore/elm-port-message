module PortMessage exposing ( PortMessage, new, withPayload)

{-| Useful functions for building a PortMessage to be delivered through ports.

@docs PortMessage


# Builder

@docs new, withPayload

-}

import Json.Encode


{-| -}
type alias PortMessage =
    { tag : String
    , payload : Json.Encode.Value
    }


{-| Create a new PortMessage with an empty payload.

    new "SomeAction" == { tag = "SomeAction", payload = null }

-}
new : String -> PortMessage
new tag =
    PortMessage tag Json.Encode.null


{-| Attach a payload to the PortMessage

    new "JoinChannel"
        |> withPayload (Json.Encode.string "lobby")
        == { tag = "JoinChannel", payload = "lobby" }

-}
withPayload : Json.Encode.Value -> PortMessage -> PortMessage
withPayload payload message =
    { message | payload = payload }
