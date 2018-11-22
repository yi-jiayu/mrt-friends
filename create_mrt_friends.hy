(import
 csv
 [util [initialise-service]])

(setv *scopes* "https://www.googleapis.com/auth/contacts")

(defn read-mrt-stations
  [csv-file]
  (with [f (open csv-file :newline "")]
        (next f) ; skip header
        (setv r (csv.reader f))
        (for [[_ name chinese-name _ _] r]
          (yield (, name chinese-name)))))

(defn create-contact
  [service details]
  (-> service
      (.people)
      (.createContact :parent "people/me"
                      :body   details)
      (.execute)))

(defn create-mrt-friend
  [service name chinese-name]
  (create-contact service
                  {"names"       [{"givenName" name}]
                   "userDefined" [{"key"   "chineseName"
                                   "value" chinese-name}]}))

(defmain [&rest args]
         (setv service (initialise-service *scopes* "credentials.json" "token.json"))
         (setv mrt-stations
               (read-mrt-stations "train-station-chinese-names/train-station-chinese-names.csv"))
         (for [station (take 5 (rest mrt-stations))]
           (print (create-mrt-friend service (unpack-iterable station)))))
