String formatCurrency(double value) {
  if (value >= 1000) {
    return 'ETB ${(value / 1000).toStringAsFixed(1)}K';
  }
  return 'ETB ${value.toStringAsFixed(2)}';
}

String formatDate(DateTime date) {
  return '${date.day}/${date.month}/${date.year}';
}

String formatTimeAgo(DateTime date) {
  final now = DateTime.now();
  final difference = now.difference(date);

  if (difference.inDays > 365) {
    final years = (difference.inDays / 365).floor();
    return '$years year${years > 1 ? 's' : ''} ago';
  } else if (difference.inDays > 30) {
    final months = (difference.inDays / 30).floor();
    return '$months month${months > 1 ? 's' : ''} ago';
  } else if (difference.inDays > 0) {
    return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
  } else if (difference.inHours > 0) {
    return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
  } else {
    return 'Just now';
  }
}
