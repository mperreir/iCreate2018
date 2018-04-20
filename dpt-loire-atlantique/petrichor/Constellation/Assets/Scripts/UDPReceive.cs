using UnityEngine;
using System.Collections;

using System;
using System.Text;
using System.Net;
using System.Net.Sockets;
using System.Threading;

public class UDPReceive : MonoBehaviour
{
    Thread receiveThread;   // Receive = blocking operation, receiving must run in a separated thread
    bool dontStop;
    UdpClient client;
    public int port;
    public Controler controller;

    // Use this for initialization
    public void Start()
    {
        port = 5005;
        print("UDP Receive : listening on port " + port);
        dontStop = true;
        Init();
    }

    // Update is called once per frame
    void Update()
    {

    }

    // Method called on destruction of the MonoBehavior
    void OnDisable()
    {
        dontStop = false;
        receiveThread.Abort();
    }

    // init
    private void Init()
    {
        receiveThread = new Thread(new ThreadStart(ReceiveData));
        receiveThread.IsBackground = true;
        receiveThread.Start();
    }

    // Receive UDP messages
    private void ReceiveData()
    {
        client = new UdpClient(port);
        while (dontStop)
        {
            try
            {
                IPEndPoint anyIP = new IPEndPoint(IPAddress.Any, 0);    // EndPoint of the network
                byte[] data = client.Receive(ref anyIP);                // Array filled with received data
                string text = Encoding.UTF8.GetString(data);
		
		print(text);
                if (text == "clavier") controller.KeyAction();
		if (text == "charriot") controller.ReturnAction();
		if (text == "tab") controller.TabAction();
		if (text == "Ding") controller.DingAction();
            }
            catch (Exception err)
            {
                print(err);
            }
        }
    }
}
