# elm-port-message

A clean convention for sending messages via ports.

> Thanks to [@splodingsocks](https://github.com/splodingsocks) for the inspiration to not create a separate port
for each Cmd/Sub. [The Importance of Ports](https://www.youtube.com/watch?v=P3pL85n9_5s)

## Background
Dropping into javascript to provide functionality not yet available in Elm
doesn't have to be the wild west. Instead of creating a port for every usecase,
why not create a single port for each direction required per module/feature then expose functions from your port module that simply build up a `PortMessage` before its passed into your port.

## Example Port Module (Document.elm)
We encode a string here in the payload but you can encode anything you need.
```elm
port module Document exposing (modifyTitle)

import Json.Encode
import PortMessage exposing (PortMessage)


modifyTitle : String -> Cmd a
modifyTitle title =
    PortMessage.new "ModifyTitle"
        |> PortMessage.withPayload (Json.Encode.string title)
        |> document


port document : PortMessage -> Cmd a
```

## Example Port Module (View.elm)
None of the functions exposed from this API require any payload so the payload will simply be `null` in js.
```elm
port module View exposing (enterFullscreen, leaveFullscreen, toggleFullscreen)

import PortMessage exposing (PortMessage)


enterFullscreen : Cmd a
enterFullscreen =
    PortMessage.new "EnterFullscreen"
        |> view

leaveFullscreen : Cmd a
leaveFullscreen =
    PortMessage.new "LeaveFullscreen"
        |> view

toggleFullscreen : Cmd a
toggleFullscreen =
    PortMessage.new "ToggleFullscreen"
        |> view

port view : PortMessage -> Cmd a
```

## Elm Usage
```elm
import Document
import View

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        TextInput value ->
            ({ model | text = value }, Document.modifyTitle value)

        -- Note we don't have the awkward identity `()` argument from having
        -- a port that doesn't require any additional data.
        FullscreenBtnPressed ->
            (model, View.enterFullscreen)
```

## Javascript Usage
```elm
const app = Elm.App.fullscreen();

app.ports.document.subscribe({ tag, payload } => {
  switch (tag) {
    case 'ModifyTitle':
      document.title = payload;
      break;
  }
});

app.ports.view.subscribe({ tag, payload } => {
  // same as above but has cases for 'EnterFullscreen', 'LeaveFullscreen' and
  // 'ToggleFullscreen'
});
```

## Ports.elm or Separate Modules?
How you structure your ports whether you decide to have a single `Ports` module
or split it up into different modules by feature or API is entirely your choice
and this package will work either way. Personally I like having separate modules for each service `File.elm`, `Phoenix.elm`, `Document.elm` over a single module for everything for several reasons.

1. Sharing code between projects. It's easy to just copy a small focused port module to another project without bringing along services that are not required.

2. The port modules can have other functionality that's not related to working with the port, for example the `File` module may expose `load : Filename -> Cmd a` where `Filename` is a type defined in `File.elm`, or maybe `bytesize : File -> Int` again where `File` is a record alias defined in `File.elm`.

3. It feels more natural, compare
`Ports.join`, `Ports.joinChannel`, `Ports.joinPhoenixChannel` or my favourite `Phoenix.join`

4. Faster compile times.

## Contributing

I'm happy to receive any feedback and ideas for about additional features. Any
input and pull requests are very welcome and encouraged. If you'd like to help
or have ideas, get in touch with me at @Hendore in the elmlang Slack!
