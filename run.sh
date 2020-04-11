#!/bin/zsh
resultDir="classes/"
buildDir="build/"
libName="termint"

buildKey="-b"
notCompileKey="-nc"
hardCompileKey="-hc"
cleanRepKey="-cr"

gitignore=".gitignore\n$resultDir\n$buildDir"

echo $gitignore > .gitignore

function compile {
    javac -classpath . -d $resultDir **/**/*.java
}

function hardCompile {
    rm $resultDir -r -f 2 > /dev/null
    mkdir $resultDir
    compile
}

function build {
    if [ -d $buildDir ]
    then
        rm $buildDir -f -r
    fi

    mkdir $buildDir

    cd $resultDir
    jar cf $libName.jar ./**/*.class
    cd ..

    mv $resultDir/$libName.jar $buildDir/$libName.jar
}

function run {
    java -classpath $resultDir $*
}

function cleanRep {
    if [ -d $resultDir ]
    then
        rm $resultDir -r -f 2 > /dev/null
    fi

    if [ -d $buildDir ]
    then
        rm $buildDir -r -f 2 > /dev/null
    fi

    if [ -f .gitignore ]
    then
        rm .gitignore
    fi
}

if [ $# -gt 0 ]
then
    if [ $1 = $notCompileKey ]
    then
        shift
    elif [ $1 =  $hardCompileKey ]
    then
        hardCompile
        shift
    elif [ $1 = $buildKey ]
    then
        compile
        build
        shift
    elif [ $1 = $cleanRepKey ]
    then
        cleanRep
        shift
    else
        compile
    fi

    if [ $# -gt 0 ]
    then
        run $*
    fi
else
    compile
fi

