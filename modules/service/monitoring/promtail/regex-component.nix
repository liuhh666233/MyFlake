rec {
  # 服务黑名单，如下services不展示日志，以 | 隔离。
  excludeServicesRegex =
    "ModemManager|accounts-daemon|cupsd|dbus-daemon|dbus-send|dhcpcd|dnsmasq|dnsmasq-dhcp|gpg-agent|kernel|nscd|polkitd|wpa_supplicant";

  # 匹配服务日志 
  logRegexSet = {
    jsy-archiver =
      "^\\s*${timeRegexSet.Y-M-D_H-M-S}\\s*${levelRegesSet.lowerLogLevel}\\s*${any-chars}(${jobNameRegexSet.jsy-archiver})?${any-chars}(${conclusionRegexSet.datapipeline})?${any-chars}$";
    jsy-importer =
      "^\\s*${timeRegexSet.Y-M-D_H-M-S}\\s*${levelRegesSet.lowerLogLevel}\\s*${any-chars}(${jobNameRegexSet.jsy-importer})?${any-chars}(${conclusionRegexSet.datapipeline})?${any-chars}$";
    wind-importer =
      "^\\s*${timeRegexSet.Y-M-D_H-M-S}\\s*${levelRegesSet.lowerLogLevel}\\s*${any-chars}(${jobNameRegexSet.wind-importer})?${any-chars}(${conclusionRegexSet.datapipeline})?${any-chars}$";
  };

  # 匹配日志时间 
  timeRegexSet = {
    # 格式： [ 2021-09-26 08:49:31.227 ]
    Y-M-D_H-M-S =
      "\\[\\s?(?P <time>\\d{4}-\\d{2}-\\d{2}\\s?\\d{2}:\\d{2}:\\d{2}\\.\\d{3})\\s?\\]";
  };

  # 匹配日志级别 
  levelRegesSet = {
    # 格式： [info] [warning] 
    lowerLogLevel =
      "\\[(?P<level>(info|warning|error|critical|trace|debug))\\]";
    # 格式： INFO WARNING ERROR
    upperLogLevel = "(?P<level>(INFO|WARNING|ERROR|CRITICAL|TRACE|DEBUG))";
  };

  # 匹配任务名称
  jobNameRegexSet = {
    #  格式：'JSY::Archive::PriceDBDaily 2021-09-24'
    jsy-archiver =
      "(\\'JSY::Archive::(?P<archiver_job>\\S+\\s?\\d{4}-\\d{2}-\\d{2})\\'";
    #  格式：Job 'JsyMinBarArcImporterDaily 2021-09-24'
    jsy-importer =
      "(job|Job)\\s?\\'(?P<importer_job>\\S+\\s?\\d{4}-\\d{2}-\\d{2})\\'";
    #  格式： Job 'WindIndexWeightDeriverJob 2021-09-26' | Job 'WindDailyImporterJob /var/lib/wonder/warehouse/raw/wind/__DATA__/AShareCapitalization 2021-09-26'
    wind-importer =
      "(job|Job)\\s?\\'(?P<importer_job>\\S+\\s?(\\S+)?\\s?\\d{4}-\\d{2}-\\d{2})\\'";
  };

  # 匹配任务运行结果 
  conclusionRegexSet = {
    # 格式：conclusion = OK | conclusion = ALREADY_EXISTS: Output file '/var/lib/wonder/warehouse/archive/price_db/2021/09/24.arc' exists
    datapipeline = "conclusion =\\s?(?P<conclusion>(OK|\\S+:))s?";
  };

  #  匹配任意多个字符
  any-chars = ".*";
  #  匹配任意多个空格
  any-blanks = "\\s*";
}
