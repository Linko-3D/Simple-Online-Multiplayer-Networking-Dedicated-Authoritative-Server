# Simple Online Multiplayer Networking Authoritative Dedicated Server

A simple Godot multiplayer setup. Change the IP address to your cloud service public DNS, then compile and upload it as a Linux headless version with debug. The clients will connect automatically to the server. The server has full authority; players can only send inputs in order to prevent cheating. The server is the only one able to see the players’ inputs. The server selects a random map, then selects a random node in the spawn area group, obtains its dimensions, and sets a random position for the client spawned inside it.

## Tutorial to host the game online

* Create an Amazon Web Services account, then sign in to the console. At the top right, set the region to where you want to create the server (ideally East United States or West Europe).

* Create an EC2 instance. Create a key pair, name it for example **mykey**, and save it in a folder that you call **security**. Beside the checkbox **Allow SSH traffic from**, set the option to **My IP**. Click **Launch instance**.

* Go to your instance. Click the **Security** tab. Open the **Security groups** link. Click **Edit inbound rules**. Click **Add rule**, set the type to **Custom UDP**, and for the port range use the port of your game (in this demonstration project it is 8080). For the source, select **Anywhere IPv4**. Click **Save rules**.

* In your instance, copy the full Public DNS address to your game script for the constant `SERVER_IP`.

* Export a Linux build of your game. In the **Resources** tab, set the **Export mode** to **Export as dedicated server**. Export it and check **Export With Debug** in order to obtain a `.sh` file. This is the file the cloud server will run. Use a simple name such as **server** and save your project in a folder called **server**.

* Open the console. Go to the folder where you saved your key, for example:

```bash
cd "C:\Users\USERNAME\Desktop\security"
```

Then type this to connect:

```bash
ssh -i mykey.pem ec2-user@PUBLIC_DNS_HERE
```

If it asks for the fingerprint, type **yes**. Then type it again to connect; you should see a bird displayed.

To upload the file, open a new console and type this, with the path to your key and the path to your server folder:

```bash
scp -i "C:\Users\USERNAME\Desktop\security\mykey.pem" -r "C:\Users\USERNAME\Desktop\server" ec2-user@PUBLIC_DNS_HERE:~/server
```

Go back to the previous console where you are connected or use the previous command to connect again:

```bash
ssh -i mykey.pem ec2-user@PUBLIC_DNS_HERE
```
You can type **ls** to see whether the folder has been uploaded correctly.
Set the correct permissions for the files:

```bash
chmod -R +x server
```

Launch the server with this command:

```bash
./server/server.sh
```
