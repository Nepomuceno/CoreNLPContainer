# stanford-corenlp

[![Build Status](https://gabrielbico.visualstudio.com/OSS/_apis/build/status/Nepomuceno.CoreNLPContainer?branchName=master)](https://gabrielbico.visualstudio.com/OSS/_build/latest?definitionId=3&branchName=master)

Inspired on: https://github.com/NLPbox/stanford-corenlp-docker

Source At:
https://github.com/Nepomuceno/CoreNLPContainer

## Featured Tags
- `3.9.2` [(Current)](https://github.com/Nepomuceno/CoreNLPContainer/tree/master/3.9.2/english)
    -  `3.9.2-arabic` `arabic` [(Dockerfile)](https://github.com/Nepomuceno/CoreNLPContainer/tree/master/3.9.2/arabic)
    
    -  `3.9.2-chinese` `chinese` [(Dockerfile)](https://github.com/Nepomuceno/CoreNLPContainer/tree/master/3.9.2/chinese)

    -  `3.9.2-english` `english` `latest` [(Dockerfile)](https://github.com/Nepomuceno/CoreNLPContainer/tree/master/3.9.2/english)

    -  `3.9.2-english-kbp` `english-kbp` [(Dockerfile)](https://github.com/Nepomuceno/CoreNLPContainer/tree/master/3.9.2/english-kbp)

    -  `3.9.2-french` `french` [(Dockerfile)](https://github.com/Nepomuceno/CoreNLPContainer/tree/master/3.9.2/french)

    -  `3.9.2-german` `german` [(Dockerfile)](https://github.com/Nepomuceno/CoreNLPContainer/tree/master/3.9.2/german)

    -  `3.9.2-spanish` `spanish` [(Dockerfile)](https://github.com/Nepomuceno/CoreNLPContainer/tree/master/3.9.2/spanish)




This Dockerfile will build and run a release of the
[Stanford CoreNLP server](http://stanfordnlp.github.io/CoreNLP/corenlp-server.html) in a docker container.

## Usage

To download and run a [prebuilt version of the CoreNLP server](https://hub.docker.com/r/gabrielbico/stanfordcorenlp/)
from Docker Hub locally at ``http://localhost:9000``, just type:

```
docker run -p 9000:9000 gabrielbico/stanfordcorenlp
```

By default, CoreNLP will not have auth enable you can add Auth to it by seeting up the `USERNAME` and `PASSWORD` variables :

```
docker run -e USERNAME=YOUR_USER -e PASSWORD=YOUR_SECRET -p 9000:9000 -ti gabrielbico/stanfordcorenlp
```

By default, CoreNLP will use up to 4GB of RAM. You can change this by setting
the `JAVA_XMX` environment variable. Here, we are giving it 3GB:

```
docker run -e JAVA_XMX=3g -p 9000:9000 -ti gabrielbico/stanfordcorenlp
```

By default, CoreNLP will use Port 9000. You can change this by setting
the `PORT` environment variable. Here, we are mapping it top port 8000:

```
docker run -e PORT=8000 -p 8000:8000 -ti gabrielbico/stanfordcorenlp
```

By default, CoreNLP will use thimeout of 25000 ms. You can change this by setting
the `TIMEOUT` environment variable. Here, we are givint it 15000:

```
docker run -e TIMEOUT=15000 -p 9000:9000 -ti gabrielbico/stanfordcorenlp
```

In order to build and run the container from scratch (e.g. if you want to use the most current release of Stanford CoreNLP, type:

```
docker build -t stanfordcorenlp https://github.com/nepomuceno/stanford-corenlp-docker.git
docker run -p 9000:9000 stanfordcorenlp
```

In another console, you can now query the CoreNLP REST API like this (given here you have jq installed):

```sh
wget -q --post-data "Although they didn't like it, they accepted the offer." \
  'localhost:9000/?properties={"annotators":"parse","outputFormat":"json"}' \
  -O - | jq ".sentences[0].parse"
```

which will return this parse tree:

```sh
"(ROOT\n  (S\n    (SBAR (IN Although)\n      (S\n        (NP (PRP they))\n        (VP (VBD did) (RB n't)\n          (PP (IN like)\n            (NP (PRP it))))))\n    (, ,)\n    (NP (PRP they))\n    (VP (VBD accepted)\n      (NP (DT the) (NN offer)))\n    (. .)))"
```

You can also parse a file, it should be one line per sentence that you want to parse:

```sh
wget -q --post-file "./samplefile/large-book-00" \
  'localhost:9000/?properties={"annotators":"parse","outputFormat":"json"}' -O -
```

If you need the full xml output and want to configure more parameters, try:

```sh
wget -q --post-data "Although they didn't like it, they accepted the offer." \
  'localhost:9000/?properties={ \
    "annotators":"tokenize,ssplit,pos,lemma,ner,parse", \
    "ssplit.eolonly":"false", "tokenize.whitespace":"true", \
    "outputFormat":"xml"}' \
  -O results.xml
```