# Create your first function

This guide will help you create and build your own function using Node.js.

**Disclaimer: at the moment, this guide will give you a ready-to-use rootfs for Firecracker. We're working on the distribution of this rootfs.**

## Requirements

- [morty](https://github.com/polyxia-org/morty/releases/latest)
- Docker
- Git

## Create the function code

Create a directory on your machine where your function code will be stored, and initialize a new npm project: 

```bash
mkdir -p /tmp/my-first-function
cd /tmp/my-first-function
npm init -y
```

Now, create a file `handler.js` with the following content : 

```js
exports.handler = async function(req, res) {
    // `req` is an Express request object
    // See: https://expressjs.com/en/api.html#req.app
    console.log(req.body)

    // `res` is an Express response object
    // See: https://expressjs.com/en/api.html#res.app
    console.log(res)
    
    // Here you have full control on the response.
    // You can return anything you want, but you always need to set at least the response code
    return res.status(200).send("My first function !")
}
```

Your function is ready to be packaged.

## Build the function package

To package your function, execute the following command : 

```bash
morty build --name my-first-function --runtime node-19 .
```

- `--name my-first-function`: the name of the function
- `--runtime node-19` : here you indicate that you want to use the [node-19](https://github.com/polyxia-org/runtimes/tree/main/template/node-19) runtime.
- `.` : the path to the function code. As we are in the same folder, we use `.` here.

You should have a file `my-first-function.ext4.lz4` into your current working directory.


