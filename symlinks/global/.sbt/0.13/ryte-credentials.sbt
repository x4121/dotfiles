import sbt._

lazy val user = "a.grodon"
lazy val pass = (Process("pass", Seq(s"ryte/www/jfrog.io/$user")).!!).split("\n").head

credentials += Credentials("Artifactory Realm", "ryte.jfrog.io", user, pass)
