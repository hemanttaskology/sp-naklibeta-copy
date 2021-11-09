import 'package:flutter/material.dart';

//for order /jobs:	1: Open , 2: Accepted By Provider 3: Quotation Send to User
// 4: Quotation Accepted , 5: Quotation  rejected 6.
// Start Work 7: End Work 8: Jb Cancel BY User 9:Payment Received

enum JobStatusType {
  OPEN,
  PENDING,
  QUOTATION_PENDING_APPROVAL,
  ACCEPTED,
  REJECTED,
  START_JOB,
  END_JOB,
  JOB_CANCEL_BY_USER,
  PAYMENT_RECEIVED
}

extension JobStatusTypeExtension on JobStatusType {
  String get name {
    switch (this) {
      case JobStatusType.OPEN:
        return "Accept Job"; // Job is open need to be accepted

      case JobStatusType.PENDING:
        return 'Send Quotation'; //Job accepted and quotation pending to be send

      case JobStatusType.QUOTATION_PENDING_APPROVAL:
        return 'Quotation Pending Approval'; //Quotation send and waiting for approval by user

      case JobStatusType.ACCEPTED:
        return 'Quotation Accepted'; //Quotation accepted by user

      case JobStatusType.REJECTED:
        return 'Quotation Rejected'; //Quotation rejected by user

      case JobStatusType.START_JOB:
        return "Job Started"; // Quotation is accepted. Job need to be started

      case JobStatusType.END_JOB:
        return "Job Ended"; // Task complete so end job
      case JobStatusType.JOB_CANCEL_BY_USER:
        return "Job Canceled By User";
      case JobStatusType.PAYMENT_RECEIVED:
        return "Payment received"; // Payment need to be taken

      default:
        return "";
    }
  }

  Color get color {
    switch (this) {
      case JobStatusType.OPEN:
        return Colors.grey;

      case JobStatusType.PENDING:
        return Colors.purple.shade900;

      case JobStatusType.QUOTATION_PENDING_APPROVAL:
        return Colors.deepOrangeAccent;

      case JobStatusType.ACCEPTED:
        return Colors.green;

      case JobStatusType.REJECTED:
        return Colors.red.shade900;

      case JobStatusType.START_JOB:
        return Colors.black87;

      case JobStatusType.END_JOB:
        return Colors.black87;

      case JobStatusType.JOB_CANCEL_BY_USER:
        return Colors.red;

      case JobStatusType.PAYMENT_RECEIVED:
        return Colors.green.shade900;

      default:
        return Colors.black87;
    }
  }

  String get buttonText {
    switch (this) {
      case JobStatusType.OPEN:
        return "ACCEPT";

      case JobStatusType.PENDING:
        return "SEND QUOTATION";

      case JobStatusType.QUOTATION_PENDING_APPROVAL:
        return 'QUOTATION PENDING APPROVAL ';

      case JobStatusType.ACCEPTED:
        return "START JOB";

      case JobStatusType.REJECTED:
        return "SEND QUOTATION";

      case JobStatusType.START_JOB:
        return "END JOB";

      case JobStatusType.JOB_CANCEL_BY_USER:
        return "Job Canceled By User";

      case JobStatusType.END_JOB:
        return "PAYMENT RECEIVED";

      case JobStatusType.PAYMENT_RECEIVED:
        return "JOB COMPLETE";

      default:
        return "";
    }
  }
}
