(import
 [googleapiclient.discovery [build]]
 [httplib2 [Http]]
 [oauth2client [file client tools]])

(setv *scopes* "https://www.googleapis.com/auth/contacts.readonly")

(defn initialise-service
  [scopes credentials-file token-file]
  (setv store (.Storage file token-file))
  (setv creds (.get store))
  (if (or (not creds) creds.invalid)
      (setv flow (.flow_from_clientsecrets client credentials-file scopes)
            creds (.run_flow tools flow store)))
  (build "people" "v1" :http (.authorize creds (Http))))
