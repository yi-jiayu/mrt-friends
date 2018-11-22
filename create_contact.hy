(import
 [googleapiclient.discovery [build]]
 [httplib2 [Http]]
 [oauth2client [file client tools]]
 [util [initialise-service]])

(setv *scopes* "https://www.googleapis.com/auth/contacts")

(defn create-contact
  [service]
  (-> service
      (.people)
      (.createContact :parent "people/me"
                      :body
                              {"names"       [{"givenName" "Jurong East"}]
                               "userDefined" [{"key"   "chineseName"
                                               "value" "裕廊东"}]})
      (.execute)))

(defmain [&rest args]
         (setv service (initialise-service "credentials.json" "token.json"))
         (setv result (create-contact service))
         (print result))
