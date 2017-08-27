using SimpleJSON;
using System.Collections;
using System;
using UnityEngine;
using WebSocketCSharp;

public class YourScript : MonoBehaviour
{
  private string wsUrl = "ws://localhost:8080/";

  // please run the Websocket server before pressing Run in unity - (also TODO: load the yaml config in C#)

  private WebSocket ws;

  void Start()
  {
    rb = GetComponent<Rigidbody>();
    count = 0;

    var ws = new WebSocket(wsUrl);

    ws.OnError += (sender, e) =>
      Console.WriteLine("WS Error");
    // TODO: log error

    ws.OnOpen += (sender, e) =>
      Console.WriteLine("WS Connection open");

    ws.Connect();

    ws.OnMessage += Ws_OnMessage;
  }

  private void Ws_OnMessage(object sender, MessageEventArgs evt)
  {
    print("WS Message");

    string text = evt.Data;

    var blockData = JSON.Parse(text);

    string value = blockData["op"].Value;
    print(value); // ths should print "utx" every time you get an unconfirmed transaction

    string tx = blockData["x"];
    print(tx["hash"].Value);   // hash
    print(tx["size"].Value);   // block size
    print(tx["inputs"][0][...]);  // transaction input(s)
    print(tx["outputs"][0][...]); // transaction output(s)
    // look at log/ws.example.log for all the parameters
  }

}
