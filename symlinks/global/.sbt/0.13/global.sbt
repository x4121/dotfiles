addCompilerPlugin(scalafixSemanticdb)
scalacOptions ++= Seq(
    "-Xmax-classfile-name", "128",
    "-Yrangepos")
