# EM-WS-Proxy

or more specifically - EM-WS-Unity-Proxy

This is a ruby websocket proxy sample app I developed to proxy websocket requests from blockchain.info to an unity 3d project

You can find the Unity 3d project in github: makevoid/block_explorer_vr

---

### Prerequisites

Ruby 2+ and bundler installed (`gem i bundler`)

Rerun

    gem i rerun


### Install

   bundle


### Run

  rerun bundle exec ruby em-ws-unity-proxy.rb

This will start a Websocket proxy on `localhost:8080`


### Unity code

You can find some unity websocket client sample code in `tmp/unity_example.cs`

Bare in mind you have to add to your plugins this dependency (websocket-sharp.dll - DLL) - https://github.com/sta/websocket-sharp

You'll need to compile it with Visual Studio and then patch it -

search for an error on a line that contains a call to `Cubemap.CreateExternalTexture`

patch it by replacing the original line with this line:

    et = Cubemap.CreateExternalTexture(size.w, txFormat, mipLevels > 1, externalTex);


enjoy!

makevoid
