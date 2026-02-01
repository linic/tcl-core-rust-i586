# tcl-core-rust-i586
Code for generating a tcl-core-x86 image with rust-i586.
Includes a `rust-i586.tcz` for rust; an `openssl-i586.tcz` with libssl and libcrypto.
The releases are hosted on [http://tcz.facedebouc.sbs/](http://tcz.facedebouc.sbs/).
To download them from that partial mirror, you'll have to `tce-load -w tce-load-github-lfs`
and `tce-load -i tce-load-github-lfs` first. The landing page on [http://tcz.facedebouc.sbs/](http://tcz.facedebouc.sbs/)
explains why. At the time of writing, [http://tcz.facedebouc.sbs/](http://tcz.facedebouc.sbs/) supports downloading
1.93.0 from 16.x/x86/tcz. 17.x/x86/tcz should also work, but I haven't tested it yet.

## About versioning
Each `rust-x.y.z-i586.tcz` is the first version, but it lists in the Change-log
all the previous versions that were built using the method in this git repo. It's the same for the
`rust-x.y.z-i586-doc.tcz` and `openssl-x.y.z-i586.tcz`. They exist if you want to force the use of a
specific rust version. If you want the latest, the `.tcz` without a version number in the name is
that one.

## About github releases
I stopped doing github releases since 1.93.0 since I got a partial mirror on [http://tcz.facedebouc.sbs/](http://tcz.facedebouc.sbs/).
It's simpler to use `tce-load -w rust-i586.tcz` and `tce-load -i rust-i586.tcz` to load these than the previous method
described in the github releases.

## Additional stuff
[The docker image which built these can be found here](https://hub.docker.com/r/linichotmailca/tcl-core-rust-i586/tags)
