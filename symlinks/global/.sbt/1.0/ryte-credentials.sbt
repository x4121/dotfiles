import scala.sys.process._

lazy val user = "a.grodon"
lazy val pass = (s"pass ryte/www/jfrog.io/$user" !!).split("\n").head

credentials += Credentials("Artifactory Realm", "ryte.jfrog.io", user, pass)
