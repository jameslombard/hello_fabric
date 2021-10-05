# Beginner Tutorial

https://daml.com/learn/deploying-daml/daml-on-fabric

More specifically we will be:

- Setting up our Daml App, in this case a project called create-daml-app
- Building and running a local Fabric ledger with Daml support through the daml-on-fabric project
- Deploying our create-daml-app code to our Fabric ledger where it will record its state
- Running a JSON endpoint that automatically creates every endpoint we need for our Daml application
- Starting up a React UI that will consume these JSON endpoints with no lower level interaction with Daml or Fabric necessary

## Pre-requisites

- Install DAML SDK: `curl -sSL https://get.daml.com/ | sh`

Output:

``` sh
Determining latest SDK version...
Latest SDK version is 1.16.0
Downloading DAML SDK 1.16.0. This may take a while.
######################################################################## 100.0%
Extracting SDK release tarball.
Installing SDK release from directory.
Please add /home/james/.daml/bin to your PATH.
Bash completions installed for Daml assistant.
Zsh completions installed for Daml assistant.
To use them, add '~/.daml/zsh' to your $fpath, e.g. by adding the following
to the beginning of '~/.zshrc' before you call 'compinit':
fpath=(~/.daml/zsh $fpath)

Successfully installed DAML.
```

## Create DAML app

- export DAML_SDK_VERSION=1.10.0
- daml install --install-assistant=yes 1.10.0
- daml create-daml-app my-app

Output: 

```sh
WARNING: Using an outdated version of the DAML assistant.
Please upgrade to the latest stable version by running:

    daml install latest

Created a new project in "my-app" based on the template "create-daml-app".
```

## Compile DAML code to DAR file

- cd `my-app`
- daml build

Output:

```
SDK 1.17.0 has been released!
See https://github.com/digital-asset/daml/releases/tag/v1.17.0 for details.

Compiling my-app to a DAR.
Created .daml/dist/my-app-0.1.0.dar
```

## Generate frontend code

- `daml codegen js .daml/dist/my-app-0.1.0.dar -o ui/daml.js- `

Output:

``` sh
SDK 1.17.0 has been released!
See https://github.com/digital-asset/daml/releases/tag/v1.17.0 for details.

Generating 057eed1fd48c238491b8ea06b9b5bf85a5d4c9275dd3f6183e0e6b01730cc2ba
Generating 40f452260bef3f29dede136108fc08a88d5a5250310281067087da6f0baddff7
Generating 518032f41fd0175461b35ae0c9691e08b4aea55e62915f8360af2cc7a1f2ba6c
Generating 6839a6d3d430c569b2425e9391717b44ca324b88ba621d597778811b2d05031d
Generating 6c2c0667393c5f92f1885163068cd31800d2264eb088eb6fc740e11241b2bf06
Generating 733e38d36a2759688a4b2c4cec69d48e7b55ecc8dedc8067b815926c917a182a
Generating 76bf0fd12bd945762a01f8fc5bbcdfa4d0ff20f8762af490f8f41d6237c6524f
Generating 8a7806365bbd98d88b4c13832ebfa305f6abaeaf32cfa2b7dd25c4fa489b79fb
Generating 99a2705ed38c1c26cbb8fe7acf36bbf626668e167a33335de932599219e0a235
Generating bfcd37bd6b84768e86e432f5f6c33e25d9e7724a9d42e33875ff74f6348e733f
Generating c1f1f00558799eec139fb4f4c76f95fb52fa1837a5dd29600baa1c8ed1bdccfd
Generating c992e30f2d9af45aeb88558cf920ed344a9ef398c75ab1a679a6610686cbb5ac
Generating cc348d369011362a5190fe96dd1f0dfbc697fdfd10e382b9e9666f0da05961b7
Generating d14e08374fc7197d6a0de468c968ae8ba3aadbf9315476fd39071831f5923662
Generating d58cf9939847921b2aab78eaa7b427dc4c649d25e6bee3c749ace4c3f52f5c97
Generating my-app-0.1.0 (hash: e0a1616550f9496db2a00a785211d13f6803542cac378da4cc0e76607c648838)
Generating e22bce619ae24ca3b8e6519281cb5a33b64b3190cc763248b4c3f9ad5087a92c
Generating e491352788e56ca4603acc411ffe1a49fefd76ed8b163af86cf5ee5f4c38645b
Generating e6de631e9f140f1f0bac42e2066ae96f16faaba0cfe55a7201c0ce8a16723ec7
```

## Install Fabric Dependencies

### Pre-requisites

- sbt
  - Using SDKMan: 

    ```
    curl -s "https://get.sdkman.io" | bash

                                    -+syyyyyyys:
                                `/yho:`       -yd.
                            `/yh/`             +m.
                        .oho.                 hy                          .`
                        .sh/`                   :N`                `-/o`  `+dyyo:.
                    .yh:`                     `M-          `-/osysoym  :hs` `-+sys:      hhyssssssssy+
                    .sh:`                       `N:          ms/-``  yy.yh-      -hy.    `.N-````````+N.
                `od/`                         `N-       -/oM-      ddd+`     `sd:     hNNm        -N:
                :do`                           .M.       dMMM-     `ms.      /d+`     `NMMs       `do
                .yy-                             :N`    ```mMMM.      -      -hy.       /MMM:       yh
            `+d+`           `:/oo/`       `-/osyh/ossssssdNMM`           .sh:         yMMN`      /m.
            -dh-           :ymNMMMMy  `-/shmNm-`:N/-.``   `.sN            /N-         `NMMy      .m/
        `oNs`          -hysosmMMMMydmNmds+-.:ohm           :             sd`        :MMM/      yy
        .hN+           /d:    -MMMmhs/-.`   .MMMh   .ss+-                 `yy`       sMMN`     :N.
        :mN/           `N/     `o/-`         :MMMo   +MMMN-         .`      `ds       mMMh      do
        /NN/            `N+....--:/+oooosooo+:sMMM:   hMMMM:        `my       .m+     -MMM+     :N.
    /NMo              -+ooooo+/:-....`...:+hNMN.  `NMMMd`        .MM/       -m:    oMMN.     hs
    -NMd`                                    :mm   -MMMm- .s/     -MMm.       /m-   mMMd     -N.
    `mMM/                                      .-   /MMh. -dMo     -MMMy        od. .MMMs..---yh
    +MMM.                                           sNo`.sNMM+     :MMMM/        sh`+MMMNmNm+++-
    mMMM-                                           /--ohmMMM+     :MMMMm.       `hyymmmdddo
    MMMMh.                  ````                  `-+yy/`yMMM/     :MMMMMy       -sm:.``..-:-.`
    dMMMMmo-.``````..-:/osyhddddho.           `+shdh+.   hMMM:     :MmMMMM/   ./yy/` `:sys+/+sh/
    .dMMMMMMmdddddmmNMMMNNNNNMMMMMs           sNdo-      dMMM-  `-/yd/MMMMm-:sy+.   :hs-      /N`
    `/ymNNNNNNNmmdys+/::----/dMMm:          +m-         mMMM+ohmo/.` sMMMMdo-    .om:       `sh
        `.-----+/.`       `.-+hh/`         `od.          NMMNmds/     `mmy:`     +mMy      `:yy.
            /moyso+//+ossso:.           .yy`          `dy+:`         ..       :MMMN+---/oys:
            /+m:  `.-:::-`               /d+                                    +MMMMMMMNh:`
            +MN/                        -yh.                                     `+hddhy+.
        /MM+                       .sh:
        :NMo                      -sh/
        -NMs                    `/yy:
        .NMy                  `:sh+.
    `mMm`               ./yds-
    `dMMMmyo:-.````.-:oymNy:`
    +NMMMMMMMMMMMMMMMMms:`
        -+shmNMMMNmdy+:`


                                                                    Now attempting installation...


    Looking for a previous installation of SDKMAN...
    Looking for unzip...
    Looking for zip...
    Looking for curl...
    Looking for sed...
    Installing SDKMAN scripts...
    Create distribution directories...
    Getting available candidates...
    Prime the config file...
    Download script archive...
    ######################################################################## 100.0%
    Extract script archive...
    Install scripts...
    Install contributed software...
    renamed '/root/.sdkman/tmp/stage/contrib/completion' -> '/root/.sdkman/contrib/completion'
    Set version to 5.12.4 ...
    Attempt update of interactive bash profile on regular UNIX...
    Added sdkman init snippet to /root/.bashrc
    Attempt update of zsh profile...
    Updated existing /root/.zshrc



    All done!


    Please open a new terminal, or run the following in the existing one:

        source "/root/.sdkman/bin/sdkman-init.sh"

    Then issue the following command:

        sdk help

    Enjoy!!!

    ```

    Install sbt:


    ```

    $ source "$HOME/.sdkman/bin/sdkman-init.sh"
    $ 
    $ sdk install sbt 1.2.8
    ==== BROADCAST =================================================================
    * 2021-10-04: jbang 0.81.1 available on SDKMAN! https://github.com/jbangdev/jbang/releases/tag/v0.81.1
    * 2021-10-02: jbang 0.81.0 available on SDKMAN! https://github.com/jbangdev/jbang/releases/tag/v0.81.0
    * 2021-10-01: micronaut 3.0.3 available on SDKMAN!
    ================================================================================

    Downloading: sbt 1.2.8

    In progress...

    ################################################################################################################################### 100.0%

    Installing: sbt 1.2.8
    Done installing!
    ```

  - Arch-linux: `yay -S sbt`

