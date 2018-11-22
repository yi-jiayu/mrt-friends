(import
 [util [initialise-service]])

(setv *scopes* "https://www.googleapis.com/auth/contacts.readonly")

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
         (setv service (initialise-service *scopes* "credentials.json" "token.json"))
         (print "List 10 connection names")
         (setv connections (get-connections service))

         (for [person connections]
           (setv names (.get person "names" []))
           (if names
               (print (.get (first names) "displayName")))))
