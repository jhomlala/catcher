class LocalizationOptions {
  final String languageCode;
  final String notificationReportModeTitle;
  final String notificationReportModeContent;

  final String dialogReportModeTitle;
  final String dialogReportModeDescription;
  final String dialogReportModeAccept;
  final String dialogReportModeCancel;

  final String pageReportModeTitle;
  final String pageReportModeDescription;
  final String pageReportModeAccept;
  final String pageReportModeCancel;

  LocalizationOptions(
    this.languageCode, {
    this.notificationReportModeTitle = "Application error occurred",
    this.notificationReportModeContent =
        "Click here to send error report to support team.",
    this.dialogReportModeTitle = "Crash",
    this.dialogReportModeDescription =
        "Unexpected error occurred in application. Error report is ready to send to support team. Please click Accept to send error report or Cancel to dismiss report.",
    this.dialogReportModeAccept = "Accept",
    this.dialogReportModeCancel = "Cancel",
    this.pageReportModeTitle = "Crash",
    this.pageReportModeDescription =
        "Unexpected error occurred in application. Error report is ready to send to support team. Please click Accept to send error report or Cancel to dismiss report.",
    this.pageReportModeAccept = "Accept",
    this.pageReportModeCancel = "Cancel",
  });

  static LocalizationOptions buildDefaultEnglishOptions() {
    return LocalizationOptions("en");
  }

  static LocalizationOptions buildDefaultChineseOptions() {
    return LocalizationOptions("zh",
        notificationReportModeTitle: "发生应用错误",
        notificationReportModeContent: "单击此处将错误报告发送给支持团队。",
        dialogReportModeTitle: "紧急",
        dialogReportModeDescription:
            "应用程序中发生意外错误。 错误报告已准备好发送给支持团队。 请单击“接受”以发送错误报告，或单击“取消”以关闭报告。",
        dialogReportModeAccept: "接受",
        dialogReportModeCancel: "取消",
        pageReportModeTitle: "紧急",
        pageReportModeDescription:
            "应用程序中发生意外错误。 错误报告已准备好发送给支持团队。 请单击“接受”以发送错误报告，或单击“取消”以关闭报告。",
        pageReportModeAccept: "接受",
        pageReportModeCancel: "取消");
  }

  static LocalizationOptions buildDefaultHindiOptions() {
    return LocalizationOptions("hi",
        notificationReportModeTitle: "एप्लिकेशन त्रुटि हुई",
        notificationReportModeContent:
            "समर्थन टीम को त्रुटि रिपोर्ट भेजने के लिए यहां क्लिक करें।.",
        dialogReportModeTitle: "दुर्घटना",
        dialogReportModeDescription:
            "आवेदन में अप्रत्याशित त्रुटि हुई। त्रुटि रिपोर्ट समर्थन टीम को भेजने के लिए तैयार है। कृपया त्रुटि रिपोर्ट भेजने के लिए स्वीकार करें या रिपोर्ट को रद्द करने के लिए रद्द करें पर क्लिक करें।",
        dialogReportModeAccept: "स्वीकार करना",
        dialogReportModeCancel: "रद्द करना",
        pageReportModeTitle: "दुर्घटना",
        pageReportModeDescription:
            "आवेदन में अप्रत्याशित त्रुटि हुई। त्रुटि रिपोर्ट समर्थन टीम को भेजने के लिए तैयार है। कृपया त्रुटि रिपोर्ट भेजने के लिए स्वीकार करें या रिपोर्ट को रद्द करने के लिए रद्द करें पर क्लिक करें।",
        pageReportModeAccept: "स्वीकार करना",
        pageReportModeCancel: "रद्द करना");
  }

  static LocalizationOptions buildDefaultSpanishOptions() {
    return LocalizationOptions("es",
        notificationReportModeTitle: "Error de aplicación ocurrió",
        notificationReportModeContent:
            "Haga clic aquí para enviar un informe de error al equipo de soporte.",
        dialogReportModeTitle: "Choque",
        dialogReportModeDescription:
            "Se ha producido un error inesperado en la aplicación. El informe de errores está listo para enviar al equipo de soporte. Haga clic en Aceptar para enviar el informe de errores o en Cancelar para cancelar el informe.",
        dialogReportModeAccept: "Aceptar",
        dialogReportModeCancel: "Cancelar",
        pageReportModeTitle: "Choque",
        pageReportModeDescription:
            "Se ha producido un error inesperado en la aplicación. El informe de errores está listo para enviar al equipo de soporte. Haga clic en Aceptar para enviar el informe de errores o en Cancelar para cancelar el informe.",
        pageReportModeAccept: "Aceptar",
        pageReportModeCancel: "Cancelar");
  }

  static LocalizationOptions buildDefaultMalayOptions() {
    return LocalizationOptions("ms",
        notificationReportModeTitle: "Ralat permohonan berlaku",
        notificationReportModeContent:
            "Klik di sini untuk menghantar laporan ralat untuk menyokong pasukan.",
        dialogReportModeTitle: "Kemalangan",
        dialogReportModeDescription:
            "Ralat tidak dijangka berlaku dalam aplikasi. Laporan ralat sedia dihantar untuk menyokong pasukan. Sila klik Terima untuk menghantar laporan ralat atau Batal untuk menolak laporan.",
        dialogReportModeAccept: "Terima",
        dialogReportModeCancel: "Batalkan",
        pageReportModeTitle: "Kemalangan",
        pageReportModeDescription:
            "Ralat tidak dijangka berlaku dalam aplikasi. Laporan ralat sedia dihantar untuk menyokong pasukan. Sila klik Terima untuk menghantar laporan ralat atau Batal untuk menolak laporan.",
        pageReportModeAccept: "Terima",
        pageReportModeCancel: "Batalkan");
  }

  static LocalizationOptions buildDefaultRussianOptions() {
    return LocalizationOptions("ru",
        notificationReportModeTitle: "Произошла ошибка приложения",
        notificationReportModeContent:
            "Нажмите здесь, чтобы отправить отчет об ошибке в службу поддержки.",
        dialogReportModeTitle: "авария",
        dialogReportModeDescription:
            "В приложении произошла непредвиденная ошибка. Отчет об ошибке готов к отправке в службу поддержки. Пожалуйста, нажмите Принять, чтобы отправить отчет об ошибке или Отмена, чтобы закрыть отчет.",
        dialogReportModeAccept: "принимать",
        dialogReportModeCancel: "отменить",
        pageReportModeTitle: "авария",
        pageReportModeDescription:
            "В приложении произошла непредвиденная ошибка. Отчет об ошибке готов к отправке в службу поддержки. Пожалуйста, нажмите Принять, чтобы отправить отчет об ошибке или Отмена, чтобы закрыть отчет.",
        pageReportModeAccept: "принимать",
        pageReportModeCancel: "отменить");
  }

  static LocalizationOptions buildDefaultPortugueseOptions() {
    return LocalizationOptions("pt",
        notificationReportModeTitle: "Erro na aplicação",
        notificationReportModeContent:
            "Clique aqui para enviar o relatório de erros à equipe de suporte.",
        dialogReportModeTitle: "Erro",
        dialogReportModeDescription:
            "Ocorreu um erro inesperado no aplicativo. O relatório de erros está pronto para ser enviado à equipe de suporte. Por favor, clique em Aceitar para enviar o relatório de erros ou em Cancelar para descartar o relatório.",
        dialogReportModeAccept: "Aceitar",
        dialogReportModeCancel: "Cancelar",
        pageReportModeTitle: "Erro",
        pageReportModeDescription:
            "Ocorreu um erro inesperado no aplicativo. O relatório de erros está pronto para ser enviado à equipe de suporte. Por favor, clique em Aceitar para enviar o relatório de erros ou em Cancelar para descartar o relatório.",
        pageReportModeAccept: "Aceitar",
        pageReportModeCancel: "Cancelar");
  }

  static LocalizationOptions buildDefaultFrenchOptions() {
    return LocalizationOptions("fr",
        notificationReportModeTitle: "Une erreur d'application s'est produite",
        notificationReportModeContent:
            "Cliquez ici pour envoyer un rapport d'erreur à l'équipe de support.",
        dialogReportModeTitle: "Fracas",
        dialogReportModeDescription:
            "Une erreur inattendue s'est produite dans l'application. Le rapport d'erreur est prêt à être envoyé à l'équipe de support. Cliquez sur Accepter pour envoyer le rapport d'erreur ou sur Annuler pour rejeter le rapport.",
        dialogReportModeAccept: "Acceptez",
        dialogReportModeCancel: "Annuler",
        pageReportModeTitle: "Fracas",
        pageReportModeDescription:
            "Une erreur inattendue s'est produite dans l'application. Le rapport d'erreur est prêt à être envoyé à l'équipe de support. Cliquez sur Accepter pour envoyer le rapport d'erreur ou sur Annuler pour rejeter le rapport.",
        pageReportModeAccept: "Acceptez",
        pageReportModeCancel: "Annuler");
  }

  static LocalizationOptions buildDefaultPolishOptions() {
    return LocalizationOptions("pl",
        notificationReportModeTitle: "Wystąpił błąd aplikacji",
        notificationReportModeContent:
            "Naciśnij tutaj aby wysłać raport do zespołu wpsarcia",
        dialogReportModeTitle: "Błąd aplikacji",
        dialogReportModeDescription:
            "Wystąpił niespodziewany błąd aplikacji. Raport z błędem jest gotowy do wysłania do zespołu wsparcia. Naciśnij akceptuj aby wysłać raport lub odrzuć aby odrzucić raport.",
        dialogReportModeAccept: "Akceptuj",
        dialogReportModeCancel: "Odrzuć",
        pageReportModeTitle: "Błąd aplikacji",
        pageReportModeDescription:
            "Wystąpił niespodziewany błąd aplikacji. Raport z błędem jest gotowy do wysłania do zespołu wsparcia. Naciśnij akceptuj aby wysłać raport lub odrzuć aby odrzucić raport.",
        pageReportModeAccept: "Akceptuj",
        pageReportModeCancel: "Odrzuć");
  }

  static LocalizationOptions buildDefaultItalianOptions() {
    return LocalizationOptions('it',
        notificationReportModeTitle: "Si è verificato un errore",
        notificationReportModeContent:
            "Clicca qui per inviare il report relativo all'errore al team di supporto.",
        dialogReportModeTitle: "Errore",
        dialogReportModeDescription:
            "Si è verificato un errore imprevisto durante l'esecuzione. Il report è pronto per essere inviato al team di supporto. Clicca Accetta per inviare il report or Annulla per rifiutare.",
        dialogReportModeAccept: "Accetta",
        dialogReportModeCancel: "Annulla",
        pageReportModeTitle: "Errore",
        pageReportModeDescription:
            "Si è verificato un errore imprevisto durante l'esecuzione. Il report è pronto per essere inviato al team di supporto. Clicca Accetta per inviare il report or Annulla per rifiutare.",
        pageReportModeAccept: "Accetta",
        pageReportModeCancel: "Annulla");
  }

  static LocalizationOptions buildDefaultKoreanOptions() {
    return LocalizationOptions('ko',
        notificationReportModeTitle: "어플리케이션 에러 발생",
        notificationReportModeContent: "지원팀에 오류를 보고하시려면 여기를 클릭하세요",
        dialogReportModeTitle: "에러",
        dialogReportModeDescription:
            "어플리케이션에서 예기치 않은 오류가 발생했습니다. 지원팀에 오류를 보고할 준비가 되어 있으니 수락을 클릭하여 오류 보고서를 전송하시거나 취소를 클릭하여 보고서를 닫으세요.",
        dialogReportModeAccept: "수락",
        dialogReportModeCancel: "취소",
        pageReportModeTitle: "에러",
        pageReportModeDescription:
            "어플리케이션에서 예기치 않은 오류가 발생했습니다. 지원팀에 오류를 보고할 준비가 되어 있으니 수락을 클릭하여 오류 보고서를 전송하시거나 취소를 클릭하여 보고서를 닫으세요.",
        pageReportModeAccept: "수락",
        pageReportModeCancel: "취소");
  }
}
