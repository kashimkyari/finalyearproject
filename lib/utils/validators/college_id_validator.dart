String validateCollegeId(String collegeId) {
  if (collegeId.trim().length < 9) {
    return "College id must be 9 characters at least";
  }
  return null;
}
