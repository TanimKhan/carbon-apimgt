CREATE TABLE IF NOT EXISTS AM_API_POLICY (
            UUID VARCHAR(256),
            NAME VARCHAR(512) NOT NULL,
            DISPLAY_NAME VARCHAR(512) NULL DEFAULT NULL,
            DESCRIPTION VARCHAR (1024),
            DEFAULT_QUOTA_TYPE VARCHAR(25) NOT NULL,
            DEFAULT_QUOTA INTEGER NOT NULL,
            DEFAULT_QUOTA_UNIT VARCHAR(10) NULL,
            DEFAULT_UNIT_TIME INTEGER NOT NULL,
            DEFAULT_TIME_UNIT VARCHAR(25) NOT NULL,
            APPLICABLE_LEVEL VARCHAR(25) NOT NULL,
            IS_DEPLOYED TINYINT(1) NOT NULL DEFAULT 0,
            PRIMARY KEY (UUID),
            UNIQUE (NAME)
);

CREATE TABLE IF NOT EXISTS AM_CONDITION_GROUP (
            CONDITION_GROUP_ID INTEGER AUTO_INCREMENT,
            UUID VARCHAR(256),
            QUOTA_TYPE VARCHAR(25),
            QUOTA INTEGER NOT NULL,
            QUOTA_UNIT VARCHAR(10) NULL DEFAULT NULL,
            UNIT_TIME INTEGER NOT NULL,
            TIME_UNIT VARCHAR(25) NOT NULL,
            DESCRIPTION VARCHAR (1024) NULL DEFAULT NULL,
            PRIMARY KEY (CONDITION_GROUP_ID),
            FOREIGN KEY (UUID) REFERENCES AM_API_POLICY(UUID) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS AM_QUERY_PARAMETER_CONDITION (
            QUERY_PARAMETER_ID INTEGER NOT NULL AUTO_INCREMENT,
            CONDITION_GROUP_ID INTEGER NOT NULL,
            PARAMETER_NAME VARCHAR(255) DEFAULT NULL,
            PARAMETER_VALUE VARCHAR(255) DEFAULT NULL,
	    	IS_PARAM_MAPPING BOOLEAN DEFAULT 1,
            PRIMARY KEY (QUERY_PARAMETER_ID),
            FOREIGN KEY (CONDITION_GROUP_ID) REFERENCES AM_CONDITION_GROUP(CONDITION_GROUP_ID) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS AM_HEADER_FIELD_CONDITION (
            HEADER_FIELD_ID INTEGER NOT NULL AUTO_INCREMENT,
            CONDITION_GROUP_ID INTEGER NOT NULL,
            HEADER_FIELD_NAME VARCHAR(255) DEFAULT NULL,
            HEADER_FIELD_VALUE VARCHAR(255) DEFAULT NULL,
	    	IS_HEADER_FIELD_MAPPING BOOLEAN DEFAULT 1,
            PRIMARY KEY (HEADER_FIELD_ID),
            FOREIGN KEY (CONDITION_GROUP_ID) REFERENCES AM_CONDITION_GROUP(CONDITION_GROUP_ID) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS AM_JWT_CLAIM_CONDITION (
            JWT_CLAIM_ID INTEGER NOT NULL AUTO_INCREMENT,
            CONDITION_GROUP_ID INTEGER NOT NULL,
            CLAIM_URI VARCHAR(512) DEFAULT NULL,
            CLAIM_ATTRIB VARCHAR(1024) DEFAULT NULL,
	        IS_CLAIM_MAPPING BOOLEAN DEFAULT 1,
            PRIMARY KEY (JWT_CLAIM_ID),
            FOREIGN KEY (CONDITION_GROUP_ID) REFERENCES AM_CONDITION_GROUP(CONDITION_GROUP_ID) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS AM_IP_CONDITION (
  AM_IP_CONDITION_ID INT NOT NULL AUTO_INCREMENT,
  STARTING_IP VARCHAR(45) NULL,
  ENDING_IP VARCHAR(45) NULL,
  SPECIFIC_IP VARCHAR(45) NULL,
  WITHIN_IP_RANGE BOOLEAN DEFAULT 1,
  CONDITION_GROUP_ID INT NULL,
  PRIMARY KEY (AM_IP_CONDITION_ID),
   FOREIGN KEY (CONDITION_GROUP_ID)    REFERENCES AM_CONDITION_GROUP (CONDITION_GROUP_ID)  ON DELETE CASCADE ON UPDATE CASCADE);

CREATE TABLE `AM_APPLICATION_POLICY` (
  `UUID` VARCHAR(255),
  `NAME` VARCHAR(512) NOT NULL,
  `DISPLAY_NAME` VARCHAR(512) NULL DEFAULT NULL,
  `DESCRIPTION` VARCHAR(1024) NULL DEFAULT NULL,
  `QUOTA_TYPE` VARCHAR(25) NOT NULL,
  `QUOTA` INT(11) NOT NULL,
  `QUOTA_UNIT` VARCHAR(10) NULL DEFAULT NULL,
  `UNIT_TIME` INT(11) NOT NULL,
  `TIME_UNIT` VARCHAR(25) NOT NULL,
  `IS_DEPLOYED` TINYINT(1) NOT NULL DEFAULT 0,
  `CUSTOM_ATTRIBUTES` BLOB DEFAULT NULL,
  PRIMARY KEY (UUID),
  UNIQUE INDEX APP_POLICY_NAME(`NAME`)
  );

CREATE TABLE `AM_SUBSCRIPTION_POLICY` (
  `UUID` VARCHAR(255),
  `NAME` VARCHAR(255),
  `DISPLAY_NAME` VARCHAR(512),
  `DESCRIPTION` VARCHAR(1024),
  `QUOTA_TYPE` VARCHAR(30),
  `QUOTA` INTEGER,
  `QUOTA_UNIT` VARCHAR(30),
  `UNIT_TIME` INTEGER,
  `TIME_UNIT` VARCHAR(30),
  `RATE_LIMIT_COUNT` INTEGER,
  `RATE_LIMIT_TIME_UNIT` VARCHAR(30),
  `IS_DEPLOYED` BOOL,
  `CUSTOM_ATTRIBUTES` BLOB,
  `STOP_ON_QUOTA_REACH` BOOL,
  `BILLING_PLAN` VARCHAR(30),
  PRIMARY KEY (`UUID`),
  UNIQUE (`NAME`)
);

CREATE TABLE `AM_API` (
  `UUID` VARCHAR(255),
  `PROVIDER` VARCHAR(255),
  `NAME` VARCHAR(255),
  `CONTEXT` VARCHAR(255),
  `VERSION` VARCHAR(30),
  `IS_DEFAULT_VERSION` BOOLEAN,
  `DESCRIPTION` VARCHAR(1024),
  `VISIBILITY` VARCHAR(30),
  `IS_RESPONSE_CACHED` BOOLEAN,
  `CACHE_TIMEOUT` INTEGER,
  `TECHNICAL_OWNER` VARCHAR(255),
  `TECHNICAL_EMAIL` VARCHAR(255),
  `BUSINESS_OWNER` VARCHAR(255),
  `BUSINESS_EMAIL` VARCHAR(255),
  `LIFECYCLE_INSTANCE_ID` VARCHAR(255),
  `CURRENT_LC_STATUS` VARCHAR(255),
  `CORS_ENABLED` BOOLEAN,
  `CORS_ALLOW_ORIGINS` VARCHAR(512),
  `CORS_ALLOW_CREDENTIALS` BOOLEAN,
  `CORS_ALLOW_HEADERS` VARCHAR(512),
  `CORS_ALLOW_METHODS` VARCHAR(255),
  `CREATED_BY` VARCHAR(100),
  `CREATED_TIME` TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP(6),
  `LAST_UPDATED_TIME` TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP(6),
  `COPIED_FROM_API` VARCHAR(255),
  PRIMARY KEY (`UUID`),
  UNIQUE (`PROVIDER`,`NAME`,`VERSION`),
  UNIQUE (`CONTEXT`,`VERSION`)
);

CREATE TABLE `AM_API_VISIBLE_ROLES` (
  `API_ID` VARCHAR(255),
  `ROLE` VARCHAR(255),
  PRIMARY KEY (`API_ID`, `ROLE`),
  FOREIGN KEY (`API_ID`) REFERENCES `AM_API`(`UUID`) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE `AM_API_TAG_MAPPING` (
  `API_ID` VARCHAR(255),
  `TAG_ID` VARCHAR(255),
  PRIMARY KEY (`API_ID`, `TAG_ID`),
  FOREIGN KEY (`API_ID`) REFERENCES `AM_API`(`UUID`) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE `AM_TAGS` (
  `TAG_ID` VARCHAR(255),
  `NAME` VARCHAR(255),
  `COUNT` INTEGER,
  PRIMARY KEY (`TAG_ID`)
);

CREATE TABLE `AM_API_SUBSCRIPTION_POLICY_MAPPING` (
  `API_ID` VARCHAR(255),
  `SUBSCRIPTION_POLICY_ID` VARCHAR(255),
  PRIMARY KEY (`API_ID`, `SUBSCRIPTION_POLICY_ID`),
  FOREIGN KEY (`API_ID`) REFERENCES `AM_API`(`UUID`) ON UPDATE CASCADE ON DELETE CASCADE,
  FOREIGN KEY (`SUBSCRIPTION_POLICY_ID`) REFERENCES `AM_SUBSCRIPTION_POLICY`(`UUID`) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE `AM_API_ENDPOINTS` (
  `API_ID` VARCHAR(255),
  `ENVIRONMENT_CATEGORY` VARCHAR(30),
  `ENDPOINT_TYPE` VARCHAR(30),
  `IS_ENDPOINT_SECURED` BOOLEAN,
  `TPS` INTEGER,
  `AUTH_DIGEST` VARCHAR(30),
  `USERNAME` VARCHAR(255),
  `PASSWORD` VARCHAR(255),
  PRIMARY KEY (`API_ID`),
  FOREIGN KEY (`API_ID`) REFERENCES `AM_API`(`UUID`) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE `AM_API_URL_MAPPING` (
  `API_ID` VARCHAR(255),
  `HTTP_METHOD` VARCHAR(30),
  `URL_PATTERN` VARCHAR(255),
  `AUTH_SCHEME` VARCHAR(30),
  `API_POLICY_ID` VARCHAR(255),
  PRIMARY KEY (`API_ID`, `HTTP_METHOD`, `URL_PATTERN`),
  FOREIGN KEY (`API_ID`) REFERENCES `AM_API`(`UUID`) ON UPDATE CASCADE ON DELETE CASCADE,
  FOREIGN KEY (`API_POLICY_ID`) REFERENCES `AM_API_POLICY`(`UUID`)
);

CREATE TABLE `AM_APPLICATION` (
  `UUID` VARCHAR(255),
  `NAME` VARCHAR(255),
  `APPLICATION_POLICY_ID` VARCHAR(255),
  `CALLBACK_URL` VARCHAR(512),
  `DESCRIPTION` VARCHAR(1024),
  `APPLICATION_STATUS` VARCHAR(255),
  `GROUP_ID` VARCHAR(255) NULL DEFAULT NULL,
  `CREATED_BY` VARCHAR(100),
  `CREATED_TIME` TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP(6),
  `UPDATED_BY` VARCHAR(100),
  `LAST_UPDATED_TIME` TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`UUID`),
  UNIQUE (NAME),
  FOREIGN KEY (`APPLICATION_POLICY_ID`) REFERENCES `AM_APPLICATION_POLICY`(`UUID`) ON UPDATE CASCADE
);

CREATE TABLE `AM_APP_KEY_MAPPING` (
  `APPLICATION_ID` VARCHAR(255),
  `CONSUMER_KEY` VARCHAR(255),
  `KEY_TYPE` VARCHAR(255),
  `STATE` VARCHAR(30),
  `CREATE_MODE` VARCHAR(30),
  PRIMARY KEY (`APPLICATION_ID`, `KEY_TYPE`),
  FOREIGN KEY (`APPLICATION_ID`) REFERENCES `AM_APPLICATION`(`UUID`) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE `AM_API_TRANSPORTS` (
  `API_ID` VARCHAR(255),
  `TRANSPORT` VARCHAR(30),
  PRIMARY KEY (`API_ID`, `TRANSPORT`),
  FOREIGN KEY (`API_ID`) REFERENCES `AM_API`(`UUID`) ON UPDATE CASCADE ON DELETE CASCADE
);


CREATE TABLE `AM_RESOURCE_CATEGORIES` (
  `RESOURCE_CATEGORY_ID` INTEGER AUTO_INCREMENT,
  `RESOURCE_CATEGORY` VARCHAR(255),
  PRIMARY KEY (`RESOURCE_CATEGORY_ID`),
  UNIQUE (`RESOURCE_CATEGORY`)
);

CREATE TABLE `AM_API_RESOURCES` (
  `UUID` VARCHAR(255),
  `API_ID` VARCHAR(255),
  `RESOURCE_CATEGORY_ID` INTEGER,
  `DATA_TYPE` VARCHAR(255),
  `RESOURCE_TEXT_VALUE` VARCHAR(1024),
  `RESOURCE_BINARY_VALUE` LONGBLOB,
  PRIMARY KEY (`UUID`),
  FOREIGN KEY (`API_ID`) REFERENCES `AM_API`(`UUID`) ON UPDATE CASCADE ON DELETE CASCADE,
  FOREIGN KEY (`RESOURCE_CATEGORY_ID`) REFERENCES `AM_RESOURCE_CATEGORIES`(`RESOURCE_CATEGORY_ID`)
);

CREATE TABLE `AM_API_DOC_META_DATA` (
  `UUID` VARCHAR(255),
  `NAME` VARCHAR(255),
  `SUMMARY` VARCHAR(1024),
  `TYPE` VARCHAR(255),
  `OTHER_TYPE_NAME` VARCHAR(255),
  `SOURCE_URL` VARCHAR(255),
  `SOURCE_TYPE` VARCHAR(255),
  `VISIBILITY` VARCHAR(30),
  PRIMARY KEY (`UUID`),
  FOREIGN KEY (`UUID`) REFERENCES `AM_API_RESOURCES`(`UUID`) ON UPDATE CASCADE ON DELETE CASCADE
 );

CREATE TABLE IF NOT EXISTS AM_SUBSCRIPTION (
  `UUID` VARCHAR(255),
  `TIER_ID` VARCHAR(50),
  `API_ID` VARCHAR(255),
  `APPLICATION_ID` VARCHAR(255),
  `SUB_STATUS` VARCHAR(50),
  `SUB_TYPE` VARCHAR(50),
  `CREATED_BY` VARCHAR(100),
  `CREATED_TIME` TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP(6),
  `UPDATED_BY` VARCHAR(100),
  `UPDATED_TIME` TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP(6),
  FOREIGN KEY(APPLICATION_ID) REFERENCES AM_APPLICATION(UUID) ON UPDATE CASCADE ON DELETE RESTRICT,
  FOREIGN KEY(API_ID) REFERENCES AM_API(UUID) ON UPDATE CASCADE ON DELETE RESTRICT,
  FOREIGN KEY(TIER_ID) REFERENCES AM_SUBSCRIPTION_POLICY(UUID) ON UPDATE CASCADE ON DELETE RESTRICT,
  PRIMARY KEY (UUID)
);