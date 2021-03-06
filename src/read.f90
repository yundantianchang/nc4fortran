submodule (nc4fortran) read
!! This submodule is for reading NetCDF via submodules

implicit none (type, external)

contains


module procedure nc_get_shape

integer :: i, tempdims(NC_MAXDIM), N, ier
character(NF90_MAX_NAME) :: tempnames(NC_MAXDIM)


if(.not.self%is_open) error stop 'ERROR:nc4fortran:read: file handle not open'

N = 0
do i = 1,NC_MAXDIM
  ier = nf90_inquire_dimension(self%ncid, dimid=i, name=tempnames(i), len=tempdims(i))
  if(ier/=NF90_NOERR) exit
  N = i
enddo
if(N==0) return  !< no good dims at all

allocate(dims(N), dimnames(N))
dims = tempdims(:N)
dimnames = tempnames(:N)

end procedure nc_get_shape


module procedure nc_check_exist
integer :: varid, ierr

exists = .false.

if(.not.self%is_open) then
  write(stderr,*) 'WARNING:nc4fortran:read: file handle not open ' // self%filename
  return
endif

ierr = nf90_inq_varid(self%ncid, dname, varid)


select case (ierr)
case (NF90_NOERR)
  exists = .true.
case (NF90_EBADID)
  write(stderr,*) 'check_exist: ERROR: is file initialized?  ', self%filename
case (NF90_ENOTVAR)
  if (self%verbose) write(stderr,*) dname, ' does not exist in ', self%filename
case default
  write(stderr,*) 'check_exist: ERROR unknown problem ', self%filename
end select

end procedure nc_check_exist

end submodule read
