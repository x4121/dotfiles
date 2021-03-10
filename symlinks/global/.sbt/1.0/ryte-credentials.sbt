import scala.sys.process._

lazy val user = "x4121"
lazy val pass = (s"pass ryte/www/jfrog.io/$user" !!).split("\n").head

credentials += Credentials("Artifactory Realm", "ryte.jfrog.io", user, pass)
