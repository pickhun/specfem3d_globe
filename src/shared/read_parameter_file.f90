!=====================================================================
!
!          S p e c f e m 3 D  G l o b e  V e r s i o n  6 . 0
!          --------------------------------------------------
!
!     Main historical authors: Dimitri Komatitsch and Jeroen Tromp
!                        Princeton University, USA
!                and CNRS / University of Marseille, France
!                 (there are currently many more authors!)
! (c) Princeton University and CNRS / University of Marseille, April 2014
!
! This program is free software; you can redistribute it and/or modify
! it under the terms of the GNU General Public License as published by
! the Free Software Foundation; either version 2 of the License, or
! (at your option) any later version.
!
! This program is distributed in the hope that it will be useful,
! but WITHOUT ANY WARRANTY; without even the implied warranty of
! MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
! GNU General Public License for more details.
!
! You should have received a copy of the GNU General Public License along
! with this program; if not, write to the Free Software Foundation, Inc.,
! 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
!
!=====================================================================

!!!!!! VERY IMPORTANT
!!!!!! VERY IMPORTANT
!!!!!! VERY IMPORTANT if you add new parameters to DATA/Par_file, remember to also
!!!!!! VERY IMPORTANT broadcast them with MPI_BCAST in src/shared/broadcast_computed_parameters.f90
!!!!!! VERY IMPORTANT otherwise the code will *NOT* work
!!!!!! VERY IMPORTANT
!!!!!! VERY IMPORTANT

  subroutine read_parameter_file()

  use constants
  use shared_input_parameters

  implicit none

! local variables
  integer :: ierr

  ! sets the base pathname for output files
  OUTPUT_FILES = 'OUTPUT_FILES'

  ! opens the parameter file: DATA/Par_file
  call open_parameter_file(ierr)
  if (ierr /= 0) stop 'an error occurred while opening the parameter file'

  ! reads in values
  call read_value_integer(SIMULATION_TYPE, 'SIMULATION_TYPE', ierr)
  if (ierr /= 0) stop 'an error occurred while reading the parameter file: SIMULATION_TYPE'
  call read_value_integer(NOISE_TOMOGRAPHY, 'NOISE_TOMOGRAPHY', ierr)
  if (ierr /= 0) stop 'an error occurred while reading the parameter file: NOISE_TOMOGRAPHY'
  call read_value_logical(SAVE_FORWARD, 'SAVE_FORWARD', ierr)
  if (ierr /= 0) stop 'an error occurred while reading the parameter file: SAVE_FORWARD'
  call read_value_integer(NCHUNKS, 'NCHUNKS', ierr)
  if (ierr /= 0) stop 'an error occurred while reading the parameter file: NCHUNKS'

  if( NCHUNKS == 6 ) then
    ! global simulations
    ANGULAR_WIDTH_XI_IN_DEGREES = 90.d0
    ANGULAR_WIDTH_ETA_IN_DEGREES = 90.d0
    CENTER_LATITUDE_IN_DEGREES = 0.d0
    CENTER_LONGITUDE_IN_DEGREES = 0.d0
    GAMMA_ROTATION_AZIMUTH = 0.d0
  else
    ! 1/2-chunk simulations
    call read_value_double_precision(ANGULAR_WIDTH_XI_IN_DEGREES, 'ANGULAR_WIDTH_XI_IN_DEGREES', ierr)
    if (ierr /= 0) stop 'an error occurred while reading the parameter file: ANGULAR_WIDTH_XI...'
    call read_value_double_precision(ANGULAR_WIDTH_ETA_IN_DEGREES, 'ANGULAR_WIDTH_ETA_IN_DEGREES', ierr)
    if (ierr /= 0) stop 'an error occurred while reading the parameter file: ANGULAR_WIDTH_ETA...'
    call read_value_double_precision(CENTER_LATITUDE_IN_DEGREES, 'CENTER_LATITUDE_IN_DEGREES', ierr)
    if (ierr /= 0) stop 'an error occurred while reading the parameter file: CENTER_LATITUDE...'
    call read_value_double_precision(CENTER_LONGITUDE_IN_DEGREES, 'CENTER_LONGITUDE_IN_DEGREES', ierr)
    if (ierr /= 0) stop 'an error occurred while reading the parameter file: CENTER_LONGITUDE...'
    call read_value_double_precision(GAMMA_ROTATION_AZIMUTH, 'GAMMA_ROTATION_AZIMUTH', ierr)
    if (ierr /= 0) stop 'an error occurred while reading the parameter file: GAMMA_ROTATION...'
  endif

  ! number of elements at the surface along the two sides of the first chunk
  call read_value_integer(NEX_XI_read, 'NEX_XI', ierr)
  if (ierr /= 0) stop 'an error occurred while reading the parameter file: NEX_XI'
  call read_value_integer(NEX_ETA_read, 'NEX_ETA', ierr)
  if (ierr /= 0) stop 'an error occurred while reading the parameter file: NEX_ETA'
  call read_value_integer(NPROC_XI_read, 'NPROC_XI', ierr)
  if (ierr /= 0) stop 'an error occurred while reading the parameter file: NPROC_XI'
  call read_value_integer(NPROC_ETA_read, 'NPROC_ETA', ierr)
  if (ierr /= 0) stop 'an error occurred while reading the parameter file: NPROC_ETA'

  ! physical parameters
  call read_value_logical(OCEANS, 'OCEANS', ierr)
  if (ierr /= 0) stop 'an error occurred while reading the parameter file: OCEANS'
  call read_value_logical(ELLIPTICITY, 'ELLIPTICITY', ierr)
  if (ierr /= 0) stop 'an error occurred while reading the parameter file: ELLIPTICITIY'
  call read_value_logical(TOPOGRAPHY, 'TOPOGRAPHY', ierr)
  if (ierr /= 0) stop 'an error occurred while reading the parameter file: TOPOGRAPHY'
  call read_value_logical(GRAVITY, 'GRAVITY', ierr)
  if (ierr /= 0) stop 'an error occurred while reading the parameter file: GRAVITY'
  call read_value_logical(ROTATION, 'ROTATION', ierr)
  if (ierr /= 0) stop 'an error occurred while reading the parameter file: ROTATION'
  call read_value_logical(ATTENUATION, 'ATTENUATION', ierr)
  if (ierr /= 0) stop 'an error occurred while reading the parameter file: ATTENUATION'

  call read_value_logical(ABSORBING_CONDITIONS, 'ABSORBING_CONDITIONS', ierr)
  if (ierr /= 0) stop 'an error occurred while reading the parameter file: ABSORBING_CONDITIONS'

  ! define the velocity model
  call read_value_string(MODEL, 'MODEL', ierr)
  if (ierr /= 0) stop 'an error occurred while reading the parameter file: MODEL'
  call read_value_double_precision(RECORD_LENGTH_IN_MINUTES, 'RECORD_LENGTH_IN_MINUTES', ierr)
  if (ierr /= 0) stop 'an error occurred while reading the parameter file: RECORD_LENGTH_IN_MINUTES'

  ! attenuation parameters
  call read_value_logical(PARTIAL_PHYS_DISPERSION_ONLY, 'PARTIAL_PHYS_DISPERSION_ONLY', ierr)
  if (ierr /= 0) stop 'an error occurred while reading the parameter file: PARTIAL_PHYS_DISPERSION_ONLY'
  call read_value_logical(UNDO_ATTENUATION, 'UNDO_ATTENUATION', ierr)
  if (ierr /= 0) stop 'an error occurred while reading the parameter file: UNDO_ATTENUATION'
  call read_value_double_precision(MEMORY_INSTALLED_PER_CORE_IN_GB, 'MEMORY_INSTALLED_PER_CORE_IN_GB', ierr)
  if (ierr /= 0) stop 'an error occurred while reading the parameter file: MEMORY_INSTALLED_PER_CORE_IN_GB'
  call read_value_double_precision(PERCENT_OF_MEM_TO_USE_PER_CORE, 'PERCENT_OF_MEM_TO_USE_PER_CORE', ierr)
  if (ierr /= 0) stop 'an error occurred while reading the parameter file: PERCENT_OF_MEM_TO_USE_PER_CORE'

  ! mass matrix corrections
  call read_value_logical(EXACT_MASS_MATRIX_FOR_ROTATION, 'EXACT_MASS_MATRIX_FOR_ROTATION', ierr)
  if (ierr /= 0) stop 'an error occurred while reading the parameter file: EXACT_MASS_MATRIX_FOR_ROTATION'

  ! low-memory Runge-Kutta time scheme
  call read_value_logical(USE_LDDRK, 'USE_LDDRK', ierr)
  if (ierr /= 0) stop 'an error occurred while reading the parameter file: USE_LDDRK'
  call read_value_logical(INCREASE_CFL_FOR_LDDRK, 'INCREASE_CFL_FOR_LDDRK', ierr)
  if (ierr /= 0) stop 'an error occurred while reading the parameter file: INCREASE_CFL_FOR_LDDRK'
  call read_value_double_precision(RATIO_BY_WHICH_TO_INCREASE_IT, 'RATIO_BY_WHICH_TO_INCREASE_IT', ierr)
  if (ierr /= 0) stop 'an error occurred while reading the parameter file: RATIO_BY_WHICH_TO_INCREASE_IT'

  ! movie options
  call read_value_logical(MOVIE_SURFACE, 'MOVIE_SURFACE', ierr)
  if (ierr /= 0) stop 'an error occurred while reading the parameter file: MOVIE_SURFACE'
  call read_value_logical(MOVIE_VOLUME, 'MOVIE_VOLUME', ierr)
  if (ierr /= 0) stop 'an error occurred while reading the parameter file: MOVIE_VOLUME'
  call read_value_logical(MOVIE_COARSE,'MOVIE_COARSE', ierr)
  if (ierr /= 0) stop 'an error occurred while reading the parameter file: MOVIE_COARSE'
  call read_value_integer(NTSTEP_BETWEEN_FRAMES, 'NTSTEP_BETWEEN_FRAMES', ierr)
  if (ierr /= 0) stop 'an error occurred while reading the parameter file: NTSTEP_BETWEEN_FRAMES'
  call read_value_double_precision(HDUR_MOVIE, 'HDUR_MOVIE', ierr)
  if (ierr /= 0) stop 'an error occurred while reading the parameter file: HDUR_MOVIE'
  call read_value_integer(MOVIE_VOLUME_TYPE, 'MOVIE_VOLUME_TYPE', ierr)
  if (ierr /= 0) stop 'an error occurred while reading the parameter file: MOVIE_VOLUME_TYPE'
  call read_value_double_precision(MOVIE_TOP_KM, 'MOVIE_TOP_KM', ierr)
  if (ierr /= 0) stop 'an error occurred while reading the parameter file: MOVIE_TOP_KM'
  call read_value_double_precision(MOVIE_BOTTOM_KM, 'MOVIE_BOTTOM_KM', ierr)
  if (ierr /= 0) stop 'an error occurred while reading the parameter file: MOVIE_BOTTOM_KM'
  call read_value_double_precision(MOVIE_WEST_DEG, 'MOVIE_WEST_DEG', ierr)
  if (ierr /= 0) stop 'an error occurred while reading the parameter file: MOVIE_WEST_DEG'
  call read_value_double_precision(MOVIE_EAST_DEG, 'MOVIE_EAST_DEG', ierr)
  if (ierr /= 0) stop 'an error occurred while reading the parameter file: MOVIE_EAST_DEG'
  call read_value_double_precision(MOVIE_NORTH_DEG, 'MOVIE_NORTH_DEG', ierr)
  if (ierr /= 0) stop 'an error occurred while reading the parameter file: MOVIE_NORTH_DEG'
  call read_value_double_precision(MOVIE_SOUTH_DEG, 'MOVIE_SOUTH_DEG', ierr)
  if (ierr /= 0) stop 'an error occurred while reading the parameter file: MOVIE_SOUTH_DEG'
  call read_value_integer(MOVIE_START, 'MOVIE_START', ierr)
  if (ierr /= 0) stop 'an error occurred while reading the parameter file: MOVIE_START'
  call read_value_integer(MOVIE_STOP, 'MOVIE_STOP', ierr)
  if (ierr /= 0) stop 'an error occurred while reading the parameter file: MOVIE_STOP'

  ! run checkpointing
  call read_value_logical(SAVE_MESH_FILES, 'SAVE_MESH_FILES', ierr)
  if (ierr /= 0) stop 'an error occurred while reading the parameter file: SAVE_MESH_FILES'
  call read_value_integer(NUMBER_OF_RUNS, 'NUMBER_OF_RUNS', ierr)
  if (ierr /= 0) stop 'an error occurred while reading the parameter file: NUMBER_OF_RUNS'
  call read_value_integer(NUMBER_OF_THIS_RUN, 'NUMBER_OF_THIS_RUN', ierr)
  if (ierr /= 0) stop 'an error occurred while reading the parameter file: NUMBER_OF_THIS_RUN'

  ! data file output directories
  call read_value_string(LOCAL_PATH, 'LOCAL_PATH', ierr)
  if (ierr /= 0) stop 'an error occurred while reading the parameter file: LOCAL_PATH'
  call read_value_string(LOCAL_TMP_PATH, 'LOCAL_TMP_PATH', ierr)
  if (ierr /= 0) stop 'an error occurred while reading the parameter file: LOCAL_TMP_PATH'

  ! user output
  call read_value_integer(NTSTEP_BETWEEN_OUTPUT_INFO, 'NTSTEP_BETWEEN_OUTPUT_INFO', ierr)
  if (ierr /= 0) stop 'an error occurred while reading the parameter file: NTSTEP_BETWEEN_OUTPUT_INFO'
  call read_value_integer(NTSTEP_BETWEEN_OUTPUT_SEISMOS, 'NTSTEP_BETWEEN_OUTPUT_SEISMOS', ierr)
  if (ierr /= 0) stop 'an error occurred while reading the parameter file: NTSTEP_BETWEEN_OUTPUT_SEISMOS'
  call read_value_integer(NTSTEP_BETWEEN_READ_ADJSRC, 'NTSTEP_BETWEEN_READ_ADJSRC', ierr)
  if (ierr /= 0) return

  ! seismogram output
  call read_value_logical(OUTPUT_SEISMOS_ASCII_TEXT, 'OUTPUT_SEISMOS_ASCII_TEXT', ierr)
  if (ierr /= 0) stop 'an error occurred while reading the parameter file: OUTPUT_SIESMOS_ASCII_TEXT'
  call read_value_logical(OUTPUT_SEISMOS_SAC_ALPHANUM, 'OUTPUT_SEISMOS_SAC_ALPHANUM', ierr)
  if (ierr /= 0) stop 'an error occurred while reading the parameter file: OUTPUT_SEISMOS_SAC_ALPHANUM'
  call read_value_logical(OUTPUT_SEISMOS_SAC_BINARY, 'OUTPUT_SEISMOS_SAC_BINARY', ierr)
  if (ierr /= 0) stop 'an error occurred while reading the parameter file: OUTPUT_SEISMOS_SAC_BINARY'
  call read_value_logical(OUTPUT_SEISMOS_ASDF, 'OUTPUT_SEISMOS_ASDF', ierr)
  if (ierr /= 0) stop 'an error occurred while reading the parameter file: OUTPUT_ASDF'
  call read_value_logical(ROTATE_SEISMOGRAMS_RT, 'ROTATE_SEISMOGRAMS_RT', ierr)
  if (ierr /= 0) stop 'an error occurred while reading the parameter file: ROTATE_SEISMOGRAMS_RT'
  call read_value_logical(WRITE_SEISMOGRAMS_BY_MASTER, 'WRITE_SEISMOGRAMS_BY_MASTER', ierr)
  if (ierr /= 0) stop 'an error occurred while reading the parameter file: WRITE_SEISMOGRAMS_BY_MASTER'
  call read_value_logical(SAVE_ALL_SEISMOS_IN_ONE_FILE, 'SAVE_ALL_SEISMOS_IN_ONE_FILE', ierr)
  if (ierr /= 0) stop 'an error occurred while reading the parameter file: SAVE_ALL_SEISMOS_IN_ONE_FILE'
  call read_value_logical(USE_BINARY_FOR_LARGE_FILE, 'USE_BINARY_FOR_LARGE_FILE', ierr)
  if (ierr /= 0) stop 'an error occurred while reading the parameter file: USE_BINARY_FOR_LARGE_FILE'
  call read_value_logical(RECEIVERS_CAN_BE_BURIED, 'RECEIVERS_CAN_BE_BURIED', ierr)
  if (ierr /= 0) stop 'an error occurred while reading the parameter file: RECEIVERS_CAN_BE_BURIED'
  call read_value_logical(PRINT_SOURCE_TIME_FUNCTION, 'PRINT_SOURCE_TIME_FUNCTION', ierr)
  if (ierr /= 0) stop 'an error occurred while reading the parameter file: PRINT_SOURCE_TIME_FUNCTION'

  ! adjoint kernels
  call read_value_logical(ANISOTROPIC_KL, 'ANISOTROPIC_KL', ierr)
  if (ierr /= 0) stop 'an error occurred while reading the parameter file: ANISOTROPIC_KL'
  call read_value_logical(SAVE_TRANSVERSE_KL_ONLY, 'SAVE_TRANSVERSE_KL_ONLY', ierr)
  if (ierr /= 0) stop 'an error occurred while reading the parameter file: SAVE_TRANSVERSE_KL_ONLY'
  call read_value_logical(APPROXIMATE_HESS_KL, 'APPROXIMATE_HESS_KL', ierr)
  if (ierr /= 0) stop 'an error occurred while reading the parameter file: APPROXIMATE_HESS_KL'
  call read_value_logical(USE_FULL_TISO_MANTLE, 'USE_FULL_TISO_MANTLE', ierr)
  if (ierr /= 0) stop 'an error occurred while reading the parameter file: USE_FULL_TISO_MANTLE'
  call read_value_logical(SAVE_SOURCE_MASK, 'SAVE_SOURCE_MASK', ierr)
  if (ierr /= 0) stop 'an error occurred while reading the parameter file: SAVE_SOURCE_MASK'
  call read_value_logical(SAVE_REGULAR_KL, 'SAVE_REGULAR_KL', ierr)
  if (ierr /= 0) stop 'an error occurred while reading the parameter file: SAVE_REGULAR_KL'

  ! GPU simulations
  call read_value_logical(GPU_MODE, 'GPU_MODE', ierr)
  if (ierr /= 0) stop 'an error occurred while reading the parameter file: GPU_MODE'
  if (GPU_MODE) then
     call read_value_integer(GPU_RUNTIME, 'GPU_RUNTIME', ierr)
     if (ierr /= 0) stop 'an error occurred while reading the parameter file: GPU_RUNTIME'
     call read_value_string(GPU_PLATFORM, 'GPU_PLATFORM', ierr)
     if (ierr /= 0) stop 'an error occurred while reading the parameter file: GPU_PLATFORM'
     call read_value_string(GPU_DEVICE, 'GPU_DEVICE', ierr)
     if (ierr /= 0) stop 'an error occurred while reading the parameter file: GPU_DEVICE'
  endif

  ! ADIOS file format output
  call read_value_logical(ADIOS_ENABLED, 'ADIOS_ENABLED', ierr)
  if (ierr /= 0) stop 'an error occurred while reading the parameter file: ADIOS_ENABLED'
  call read_value_logical(ADIOS_FOR_FORWARD_ARRAYS, 'ADIOS_FOR_FORWARD_ARRAYS', ierr)
  if (ierr /= 0) stop 'an error occurred while reading the parameter file: ADIOS_FOR_FORWARD_ARRAYS'
  call read_value_logical(ADIOS_FOR_MPI_ARRAYS, 'ADIOS_FOR_MPI_ARRAYS', ierr)
  if (ierr /= 0) stop 'an error occurred while reading the parameter file: ADIOS_FOR_MPI_ARRAYS'
  call read_value_logical(ADIOS_FOR_ARRAYS_SOLVER, 'ADIOS_FOR_ARRAYS_SOLVER', ierr)
  if (ierr /= 0) stop 'an error occurred while reading the parameter file: ADIOS_FOR_ARRAYS_SOLVER'
  call read_value_logical(ADIOS_FOR_SOLVER_MESHFILES, 'ADIOS_FOR_SOLVER_MESHFILES', ierr)
  if (ierr /= 0) stop 'an error occurred while reading the parameter file: ADIOS_FOR_SOLVER_MESHFILES'
  call read_value_logical(ADIOS_FOR_AVS_DX, 'ADIOS_FOR_AVS_DX', ierr)
  if (ierr /= 0) stop 'an error occurred while reading the parameter file: ADIOS_FOR_AVS_DX'
  call read_value_logical(ADIOS_FOR_KERNELS, 'ADIOS_FOR_KERNELS', ierr)
  if (ierr /= 0) stop 'an error occurred while reading the parameter file: ADIOS_FOR_KERNELS'
  call read_value_logical(ADIOS_FOR_MODELS, 'ADIOS_FOR_MODELS', ierr)
  if (ierr /= 0) stop 'an error occurred while reading the parameter file: ADIOS_FOR_MODELS'

  ! closes parameter file
  call close_parameter_file()

  ! ignore EXACT_MASS_MATRIX_FOR_ROTATION if rotation is not included in the simulations
  if(.not. ROTATION) EXACT_MASS_MATRIX_FOR_ROTATION = .false.

  ! produces simulations compatible with old globe version 5.1.5
  if( USE_OLD_VERSION_5_1_5_FORMAT ) then
    print*
    print*,'**************'
    print*,'using globe version 5.1.5 compatible simulation parameters'
    if( .not. ATTENUATION_1D_WITH_3D_STORAGE ) &
      stop 'ATTENUATION_1D_WITH_3D_STORAGE should be set to .true. for compatibility with globe version 5.1.5 '
    if( UNDO_ATTENUATION ) then
      print*,'setting UNDO_ATTENUATION to .false. for compatibility with globe version 5.1.5 '
      UNDO_ATTENUATION = .false.
    endif
    if( USE_LDDRK ) then
      print*,'setting USE_LDDRK to .false. for compatibility with globe version 5.1.5 '
      USE_LDDRK = .false.
    endif
    if( EXACT_MASS_MATRIX_FOR_ROTATION ) then
      print*,'setting EXACT_MASS_MATRIX_FOR_ROTATION to .false. for compatibility with globe version 5.1.5 '
      EXACT_MASS_MATRIX_FOR_ROTATION = .false.
    endif
    print*,'**************'
    print*
  endif

  ! checks flags when perfect sphere is set
  if( ASSUME_PERFECT_SPHERE ) then
    if( ELLIPTICITY ) then
      stop 'ELLIPTICITY not supported when ASSUME_PERFECT_SPHERE is set .true. in constants.h, please check...'
    endif
    if( TOPOGRAPHY ) then
      stop 'TOPOGRAPHY not supported when ASSUME_PERFECT_SPHERE is set .true. in constants.h, please check...'
    endif
  endif

!----------------------------------------------
!
! status of implementation
!
!----------------------------------------------
!
! please remove these security checks only after validating new features

!! DK DK July 2013: temporary, the time for Matthieu Lefebvre to merge his ADIOS implementation
  if( ADIOS_ENABLED .and. SAVE_REGULAR_KL ) &
    stop 'ADIOS_ENABLED support not implemented yet for SAVE_REGULAR_KL'
  if( ADIOS_ENABLED .and. UNDO_ATTENUATION .and. SIMULATION_TYPE == 3 ) &
    stop 'ADIOS_ENABLED support not implemented yet for UNDO_ATTENUATION and SIMULATION_TYPE == 3'

  if( USE_LDDRK .and. SIMULATION_TYPE == 3 ) &
    stop 'USE_LDDRK support not implemented yet for SIMULATION_TYPE == 3'
  if( USE_LDDRK .and. GPU_MODE ) &
    stop 'USE_LDDRK support not implemented yet for GPU simulations'

  if( UNDO_ATTENUATION .and. NOISE_TOMOGRAPHY > 0 ) &
    stop 'UNDO_ATTENUATION support not implemented yet for noise simulations'
  if( UNDO_ATTENUATION .and. MOVIE_VOLUME .and. MOVIE_VOLUME_TYPE == 4 ) &
    stop 'UNDO_ATTENUATION support not implemented yet for MOVIE_VOLUME_TYPE == 4 simulations'
  if( UNDO_ATTENUATION .and. GPU_MODE ) &
    stop 'UNDO_ATTENUATION support not implemented yet for GPU simulations'
  if( UNDO_ATTENUATION .and. SIMULATION_TYPE == 3 .and. (MOVIE_VOLUME .or. MOVIE_SURFACE) ) &
    stop 'UNDO_ATTENUATION support not implemented yet for SIMULATION_TYPE == 3 and movie simulations'

  end subroutine read_parameter_file
