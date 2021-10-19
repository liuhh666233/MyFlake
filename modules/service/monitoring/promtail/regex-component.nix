rec {
  # 服务黑名单，如下services不展示日志，以 | 隔离。
  excludeServicesRegex =
    "ModemManager|accounts-daemon|cupsd|dbus-daemon|dbus-send|dhcpcd|dnsmasq|dnsmasq-dhcp|gpg-agent|kernel|nscd|polkitd|wpa_supplicant";

  # 匹配服务日志 
  logRegexSet = {
    jsy-archiver =
      "^${escaping}s*${timeRegexSet.Y-M-D_H-M-S}${escaping}s*${levelRegesSet.lowerLogLevel}${escaping}s*(${jobNameRegexSet.jsy-archiver}${escaping}s*${conclusionRegexSet.datapipeline}${any-chars}${durationRegexSet})?${any-chars}$";
    jsy-importer =
      "^${escaping}s*${timeRegexSet.Y-M-D_H-M-S}${escaping}s*${levelRegesSet.lowerLogLevel}${escaping}s*(${jobNameRegexSet.jsy-importer}${escaping}s*${conclusionRegexSet.datapipeline}${any-chars}${durationRegexSet})?${any-chars}$";
    wind-importer =
      "^${escaping}s*${timeRegexSet.Y-M-D_H-M-S}${escaping}s*${levelRegesSet.lowerLogLevel}${escaping}s*(${jobNameRegexSet.wind-importer}${escaping}s*${conclusionRegexSet.datapipeline}${any-chars}${durationRegexSet})?${any-chars}$";
  };

  # 匹配日志时间 
  timeRegexSet = {
    # 格式： [ 2021-09-26 08:49:31.227 ]
    Y-M-D_H-M-S =
      "${escaping}[${escaping}s?(?P<time>${escaping}d{4}-${escaping}d{2}-${escaping}d{2}${escaping}s?${escaping}d{2}:${escaping}d{2}:${escaping}d{2}${escaping}.${escaping}d{3})${escaping}s?${escaping}]";
  };

  # 匹配日志级别 
  levelRegesSet = {
    # 格式： [info] [warning] 
    lowerLogLevel =
      "${escaping}[(?P<level>(info|warning|error|critical|trace|debug))${escaping}]";
    # 格式： INFO WARNING ERROR
    upperLogLevel = "(?P<level>(INFO|WARNING|ERROR|CRITICAL|TRACE|DEBUG))";
  };

  # 匹配任务名称
  jobNameRegexSet = {
    #  格式：'JsyDailyArchiveJob JsyPriceDBArchiver 2021-10-19' is completed, conclusion = OK, duration = 20996Ms'
    jsy-archiver =
      "${escaping}'JsyDailyArchiveJob${escaping}s?(?P<archiver_job>${escaping}S+)${escaping}s?${escaping}d{4}-${escaping}d{2}-${escaping}d{2}${escaping}s?${escaping}'";
    #  格式：'JsyDailyImporterJob JsyTickTradeArcImporter 2021-10-19' is completed, conclusion = OK, duration = 48448Ms'
    jsy-importer =
      "${escaping}'JsyDailyImporterJob${escaping}s?(?P<importer_job>${escaping}S+)${escaping}s?${escaping}d{4}-${escaping}d{2}-${escaping}d{2}${escaping}s?${escaping}'";
    #  格式：'WindDailyImporterJob WindStockRatingImporter 2021-10-19' is completed, conclusion = OK, duration = 98Ms'
    #            'WindBulkImporterJob WindFinancialStatementBulkJob' is completed, conclusion = OK, duration = 162059Ms'
    wind-importer =
      "${escaping}'(WindDailyImporterJob|WindBulkImporterJob)${escaping}s?(?P<importer_job>${escaping}S+)${escaping}s?(${escaping}d{4}-${escaping}d{2}-${escaping}d{2}${escaping}s?)?${escaping}'";
  };

  # 匹配任务运行结果 
  conclusionRegexSet = {
    # 格式：conclusion = OK | conclusion = ALREADY_EXISTS: Output file '/var/lib/wonder/warehouse/archive/price_db/2021/09/24.arc' exists
    datapipeline =
      "${escaping}s?is completed, conclusion =${escaping}s?(?P<conclusion>(OK|${escaping}S+:))${escaping}s?";
  };

  # 匹配任务耗时
  durationRegexSet = {
    datapipeline =
      "${escaping}s?duration =${escaping}s?(?P<duration>[0-9]*)Ms${escaping}s?";
  };

  #  匹配任意多个字符
  any-chars = ".*";
  # YAML中需要使用 \\ 进行转义，\\替换到YAML中会被合并为\，因此需要使用  \\\\\\\\
  escaping = "\\\\\\\\";
}
