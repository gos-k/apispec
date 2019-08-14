(defpackage #:apispec/classes/response/class
  (:use #:cl
        #:apispec/utils)
  (:import-from #:apispec/classes/header
                #:header)
  (:import-from #:apispec/classes/media-type
                #:media-type)
  (:export #:response
           #:response-description
           #:response-headers
           #:response-content
           #:responses))
(in-package #:apispec/classes/response/class)

(declaim-safety)

(defclass response ()
  ((description :type string
                :initarg :description
                :initform (error ":description is required for RESPONSE")
                :reader response-description)
   (headers :type (association-list string header)
            :initarg :headers
            :initform nil
            :reader response-headers)
   (content :type (association-list string (or media-type null))
            :initarg :content
            :initform nil
            :reader response-content)))

(defun http-status-code-p (value)
  (<= 100 value 599))

(deftype http-status-code ()
  '(and integer (satisfies http-status-code-p)))

(defun default-response-p (value)
  (equal value "default"))

(deftype responses-keys ()
  '(or http-status-code
       (and string
            (satisfies default-response-p))))

(defun responsesp (responses)
  (and (not (null responses))
       (association-list-p responses 'responses-keys 'response)))

(deftype responses ()
  '(satisfies responsesp))

(undeclaim-safety)