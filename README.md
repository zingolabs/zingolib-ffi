# Native language bindings for [Zingolib](https://github.com/zingolabs/zingolib)

⚠️ This repository is **work in progress** and is not yet ready for use.


To generate new uniffi bindings:

docker build -f buildcontainer -t buildcontainer . && docker run -v `pwd`:/home/myuser/zingolib-ffi buildcontainer
