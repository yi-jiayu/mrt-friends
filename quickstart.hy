(import
 [googleapiclient.discovery [build]]
 [httplib2 [Http]]
 [oauth2client [file client tools]])

(setv *scopes* "https://www.googleapis.com/auth/contacts.readonly")

(defn initialise-service
  [credentials-file token-file]
  (setv store (.Storage file token-file))
  (setv creds (.get store))
  (if (or (not creds) creds.invalid)
      (setv flow (.flow_from_clientsecrets client credentials-file *scopes*)
            creds (.run_flow tools flow store)))
  (build "people" "v1" :http (.authorize creds (Http))))

(defn get-connections
  [service]
  (-> service
      (.people)
      (.connections)
      (.list :resourceName "people/me"
             :pageSize     10
             :personFields "names,emailAddresses")
      (.execute)
      (.get "connections" [])))

(defmain [&rest args]
         "Shows basic usage of the People API.
Prints the name of the first 10 connections."
         (setv service (initialise-service "credentials.json" "token.json"))
         (print "List 10 connection names")
         (setv connections (get-connections service))

         (for [person connections]
           (setv names (.get person "names" []))
           (if names
               (print (.get (first names) "displayName")))))
