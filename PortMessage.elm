module PortMessage exposing (PortMessage, new, withPayload)

{-| Useful functions for building a PortMessage to be delivered through ports.

@docs PortMessage


# Builder

@docs new, withPayload

-}

import Json.Encode


{-| -}
type alias PortMessage =
    { tag : Tag
    , payload : Json.Encode.Value
    }


type alias Tag =
    String


{-| Create a new PortMessage with an empty payload.
-}
new : Tag -> PortMessage
new tag =
    PortMessage tag Json.Encode.null


{-| Attach a payload to the PortMessage
-}
withPayload : Json.Encode.Value -> PortMessage -> PortMessage
withPayload payload message =
    { message | payload = payload }