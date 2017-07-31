# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.5

# compile CXX with /usr/bin/c++
CXX_FLAGS =   -msse2  

CXX_DEFINES = -DITK_IO_FACTORY_REGISTER_MANAGER

CXX_INCLUDES = -I/home/yan/cs9535project/MattesMutualInformation/MattesMutualInformation/build/ITKIOFactoryRegistration -I/usr/local/itk/InsightToolkit-4.11.0/Modules/Segmentation/Watersheds/include -I/usr/local/itk/InsightToolkit-4.11.0/Modules/Segmentation/Voronoi/include -I/usr/local/itk/InsightToolkit-4.11.0/Modules/Video/IO/include -I/usr/local/itk/InsightToolkit-4.11.0/Modules/Video/Filtering/include -I/usr/local/itk/InsightToolkit-4.11.0/Modules/Video/Core/include -I/usr/local/itk/InsightToolkit-4.11.0/Modules/Bridge/VTK/include -I/usr/local/itk/InsightToolkit-4.11.0/Modules/Core/TestKernel/include -I/usr/local/itk/InsightToolkit-4.11.0/Modules/ThirdParty/TIFF/src -I/usr/local/itk/InsightToolkit-4.11.0/bin/Modules/ThirdParty/TIFF/src/itktiff -I/usr/local/itk/InsightToolkit-4.11.0/bin/Modules/ThirdParty/TIFF/src -I/usr/local/itk/InsightToolkit-4.11.0/Modules/Filtering/SpatialFunction/include -I/usr/local/itk/InsightToolkit-4.11.0/Modules/Registration/RegistrationMethodsv4/include -I/usr/local/itk/InsightToolkit-4.11.0/Modules/Segmentation/RegionGrowing/include -I/usr/local/itk/InsightToolkit-4.11.0/Modules/Filtering/QuadEdgeMeshFiltering/include -I/usr/local/itk/InsightToolkit-4.11.0/Modules/ThirdParty/PNG/src -I/usr/local/itk/InsightToolkit-4.11.0/bin/Modules/ThirdParty/PNG/src -I/usr/local/itk/InsightToolkit-4.11.0/Modules/ThirdParty/NrrdIO/src/NrrdIO -I/usr/local/itk/InsightToolkit-4.11.0/bin/Modules/ThirdParty/NrrdIO/src/NrrdIO -I/usr/local/itk/InsightToolkit-4.11.0/Modules/Numerics/NeuralNetworks/include -I/usr/local/itk/InsightToolkit-4.11.0/Modules/Numerics/Optimizersv4/include -I/usr/local/itk/InsightToolkit-4.11.0/Modules/Registration/Metricsv4/include -I/usr/local/itk/InsightToolkit-4.11.0/Modules/Segmentation/MarkovRandomFieldsClassifiers/include -I/usr/local/itk/InsightToolkit-4.11.0/Modules/Segmentation/LevelSetsv4/include -I/usr/local/itk/InsightToolkit-4.11.0/Modules/Segmentation/LabelVoting/include -I/usr/local/itk/InsightToolkit-4.11.0/Modules/Segmentation/KLMRegionGrowing/include -I/usr/local/itk/InsightToolkit-4.11.0/Modules/ThirdParty/JPEG/src -I/usr/local/itk/InsightToolkit-4.11.0/bin/Modules/ThirdParty/JPEG/src -I/usr/local/itk/InsightToolkit-4.11.0/Modules/Filtering/ImageNoise/include -I/usr/local/itk/InsightToolkit-4.11.0/Modules/Filtering/ImageFusion/include -I/usr/local/itk/InsightToolkit-4.11.0/Modules/IO/XML/include -I/usr/local/itk/InsightToolkit-4.11.0/Modules/IO/VTK/include -I/usr/local/itk/InsightToolkit-4.11.0/Modules/IO/TransformMatlab/include -I/usr/local/itk/InsightToolkit-4.11.0/Modules/IO/TransformInsightLegacy/include -I/usr/local/itk/InsightToolkit-4.11.0/Modules/IO/TransformHDF5/include -I/usr/local/itk/InsightToolkit-4.11.0/Modules/IO/TransformFactory/include -I/usr/local/itk/InsightToolkit-4.11.0/Modules/IO/TransformBase/include -I/usr/local/itk/InsightToolkit-4.11.0/Modules/IO/TIFF/include -I/usr/local/itk/InsightToolkit-4.11.0/Modules/IO/Stimulate/include -I/usr/local/itk/InsightToolkit-4.11.0/Modules/IO/Siemens/include -I/usr/local/itk/InsightToolkit-4.11.0/Modules/IO/RAW/include -I/usr/local/itk/InsightToolkit-4.11.0/Modules/IO/PNG/include -I/usr/local/itk/InsightToolkit-4.11.0/Modules/IO/NRRD/include -I/usr/local/itk/InsightToolkit-4.11.0/Modules/IO/NIFTI/include -I/usr/local/itk/InsightToolkit-4.11.0/Modules/IO/Meta/include -I/usr/local/itk/InsightToolkit-4.11.0/Modules/IO/Mesh/include -I/usr/local/itk/InsightToolkit-4.11.0/Modules/IO/MRC/include -I/usr/local/itk/InsightToolkit-4.11.0/Modules/IO/LSM/include -I/usr/local/itk/InsightToolkit-4.11.0/Modules/IO/JPEG/include -I/usr/local/itk/InsightToolkit-4.11.0/Modules/IO/IPL/include -I/usr/local/itk/InsightToolkit-4.11.0/Modules/IO/HDF5/include -I/usr/local/itk/InsightToolkit-4.11.0/Modules/IO/GIPL/include -I/usr/local/itk/InsightToolkit-4.11.0/Modules/IO/GE/include -I/usr/local/itk/InsightToolkit-4.11.0/Modules/IO/GDCM/include -I/usr/local/itk/InsightToolkit-4.11.0/Modules/IO/CSV/include -I/usr/local/itk/InsightToolkit-4.11.0/Modules/IO/BioRad/include -I/usr/local/itk/InsightToolkit-4.11.0/Modules/IO/BMP/include -I/usr/local/itk/InsightToolkit-4.11.0/bin/Modules/ThirdParty/HDF5/src -I/usr/local/itk/InsightToolkit-4.11.0/Modules/ThirdParty/HDF5/src -I/usr/local/itk/InsightToolkit-4.11.0/Modules/Filtering/GPUThresholding/include -I/usr/local/itk/InsightToolkit-4.11.0/Modules/Filtering/GPUSmoothing/include -I/usr/local/itk/InsightToolkit-4.11.0/Modules/Registration/GPUCommon/include -I/usr/local/itk/InsightToolkit-4.11.0/Modules/Registration/GPUPDEDeformable/include -I/usr/local/itk/InsightToolkit-4.11.0/Modules/Filtering/GPUImageFilterBase/include -I/usr/local/itk/InsightToolkit-4.11.0/Modules/Core/GPUFiniteDifference/include -I/usr/local/itk/InsightToolkit-4.11.0/Modules/Core/GPUCommon/include -I/usr/local/itk/InsightToolkit-4.11.0/Modules/Filtering/GPUAnisotropicSmoothing/include -I/usr/local/itk/InsightToolkit-4.11.0/Modules/ThirdParty/NIFTI/src/nifti/znzlib -I/usr/local/itk/InsightToolkit-4.11.0/Modules/ThirdParty/NIFTI/src/nifti/niftilib -I/usr/local/itk/InsightToolkit-4.11.0/Modules/ThirdParty/GIFTI/src/gifticlib -I/usr/local/itk/InsightToolkit-4.11.0/Modules/ThirdParty/GDCM/src/gdcm/Source/DataStructureAndEncodingDefinition -I/usr/local/itk/InsightToolkit-4.11.0/Modules/ThirdParty/GDCM/src/gdcm/Source/MessageExchangeDefinition -I/usr/local/itk/InsightToolkit-4.11.0/Modules/ThirdParty/GDCM/src/gdcm/Source/InformationObjectDefinition -I/usr/local/itk/InsightToolkit-4.11.0/Modules/ThirdParty/GDCM/src/gdcm/Source/Common -I/usr/local/itk/InsightToolkit-4.11.0/Modules/ThirdParty/GDCM/src/gdcm/Source/DataDictionary -I/usr/local/itk/InsightToolkit-4.11.0/Modules/ThirdParty/GDCM/src/gdcm/Source/MediaStorageAndFileFormat -I/usr/local/itk/InsightToolkit-4.11.0/bin/Modules/ThirdParty/GDCM/src/gdcm/Source/Common -I/usr/local/itk/InsightToolkit-4.11.0/bin/Modules/ThirdParty/GDCM -I/usr/local/itk/InsightToolkit-4.11.0/Modules/Registration/PDEDeformable/include -I/usr/local/itk/InsightToolkit-4.11.0/Modules/Registration/FEM/include -I/usr/local/itk/InsightToolkit-4.11.0/Modules/Registration/Common/include -I/usr/local/itk/InsightToolkit-4.11.0/Modules/IO/SpatialObjects/include -I/usr/local/itk/InsightToolkit-4.11.0/Modules/Numerics/FEM/include -I/usr/local/itk/InsightToolkit-4.11.0/Modules/ThirdParty/Expat/src/expat -I/usr/local/itk/InsightToolkit-4.11.0/bin/Modules/ThirdParty/Expat/src/expat -I/usr/local/itk/InsightToolkit-4.11.0/Modules/Numerics/Eigen/include -I/usr/local/itk/InsightToolkit-4.11.0/bin/Modules/ThirdParty/DoubleConversion/src/double-conversion -I/usr/local/itk/InsightToolkit-4.11.0/Modules/ThirdParty/DoubleConversion/src/double-conversion -I/usr/local/itk/InsightToolkit-4.11.0/Modules/Filtering/DisplacementField/include -I/usr/local/itk/InsightToolkit-4.11.0/Modules/Filtering/DiffusionTensorImage/include -I/usr/local/itk/InsightToolkit-4.11.0/Modules/Filtering/Denoising/include -I/usr/local/itk/InsightToolkit-4.11.0/Modules/Segmentation/DeformableMesh/include -I/usr/local/itk/InsightToolkit-4.11.0/Modules/Filtering/Deconvolution/include -I/usr/local/itk/InsightToolkit-4.11.0/Modules/ThirdParty/DICOMParser/src/DICOMParser -I/usr/local/itk/InsightToolkit-4.11.0/bin/Modules/ThirdParty/DICOMParser/src/DICOMParser -I/usr/local/itk/InsightToolkit-4.11.0/Modules/Filtering/FFT/include -I/usr/local/itk/InsightToolkit-4.11.0/Modules/Filtering/Convolution/include -I/usr/local/itk/InsightToolkit-4.11.0/Modules/Filtering/Colormap/include -I/usr/local/itk/InsightToolkit-4.11.0/Modules/Segmentation/Classifiers/include -I/usr/local/itk/InsightToolkit-4.11.0/Modules/Segmentation/BioCell/include -I/usr/local/itk/InsightToolkit-4.11.0/Modules/Numerics/Polynomials/include -I/usr/local/itk/InsightToolkit-4.11.0/Modules/Filtering/BiasCorrection/include -I/usr/local/itk/InsightToolkit-4.11.0/Modules/Segmentation/SignedDistanceFunction/include -I/usr/local/itk/InsightToolkit-4.11.0/Modules/Numerics/Optimizers/include -I/usr/local/itk/InsightToolkit-4.11.0/Modules/Filtering/ImageSources/include -I/usr/local/itk/InsightToolkit-4.11.0/Modules/Filtering/Smoothing/include -I/usr/local/itk/InsightToolkit-4.11.0/Modules/Filtering/ImageGradient/include -I/usr/local/itk/InsightToolkit-4.11.0/Modules/Filtering/ImageFeature/include -I/usr/local/itk/InsightToolkit-4.11.0/Modules/Filtering/ImageCompare/include -I/usr/local/itk/InsightToolkit-4.11.0/Modules/IO/ImageBase/include -I/usr/local/itk/InsightToolkit-4.11.0/bin/Modules/IO/ImageBase -I/usr/local/itk/InsightToolkit-4.11.0/Modules/Core/QuadEdgeMesh/include -I/usr/local/itk/InsightToolkit-4.11.0/Modules/Core/Mesh/include -I/usr/local/itk/InsightToolkit-4.11.0/Modules/Filtering/FastMarching/include -I/usr/local/itk/InsightToolkit-4.11.0/Modules/Numerics/NarrowBand/include -I/usr/local/itk/InsightToolkit-4.11.0/Modules/Filtering/ImageLabel/include -I/usr/local/itk/InsightToolkit-4.11.0/Modules/Filtering/Thresholding/include -I/usr/local/itk/InsightToolkit-4.11.0/Modules/Filtering/Path/include -I/usr/local/itk/InsightToolkit-4.11.0/Modules/ThirdParty/ZLIB/src -I/usr/local/itk/InsightToolkit-4.11.0/bin/Modules/ThirdParty/ZLIB/src -I/usr/local/itk/InsightToolkit-4.11.0/Modules/ThirdParty/MetaIO/src/MetaIO/src -I/usr/local/itk/InsightToolkit-4.11.0/bin/Modules/ThirdParty/MetaIO/src/MetaIO/src -I/usr/local/itk/InsightToolkit-4.11.0/Modules/Core/SpatialObjects/include -I/usr/local/itk/InsightToolkit-4.11.0/Modules/Filtering/ImageCompose/include -I/usr/local/itk/InsightToolkit-4.11.0/Modules/Filtering/ImageStatistics/include -I/usr/local/itk/InsightToolkit-4.11.0/Modules/Filtering/ImageIntensity/include -I/usr/local/itk/InsightToolkit-4.11.0/Modules/Segmentation/ConnectedComponents/include -I/usr/local/itk/InsightToolkit-4.11.0/Modules/Filtering/MathematicalMorphology/include -I/usr/local/itk/InsightToolkit-4.11.0/Modules/Filtering/LabelMap/include -I/usr/local/itk/InsightToolkit-4.11.0/Modules/Filtering/BinaryMathematicalMorphology/include -I/usr/local/itk/InsightToolkit-4.11.0/Modules/Filtering/DistanceMap/include -I/usr/local/itk/InsightToolkit-4.11.0/Modules/Segmentation/LevelSets/include -I/usr/local/itk/InsightToolkit-4.11.0/Modules/Filtering/AntiAlias/include -I/usr/local/itk/InsightToolkit-4.11.0/Modules/Core/Transform/include -I/usr/local/itk/InsightToolkit-4.11.0/bin/Modules/ThirdParty/Netlib -I/usr/local/itk/InsightToolkit-4.11.0/Modules/Numerics/Statistics/include -I/usr/local/itk/InsightToolkit-4.11.0/Modules/Core/ImageAdaptors/include -I/usr/local/itk/InsightToolkit-4.11.0/Modules/Core/ImageFunction/include -I/usr/local/itk/InsightToolkit-4.11.0/Modules/Filtering/ImageGrid/include -I/usr/local/itk/InsightToolkit-4.11.0/Modules/Filtering/ImageFilterBase/include -I/usr/local/itk/InsightToolkit-4.11.0/bin/Modules/ThirdParty/VNL/src/vxl/core -I/usr/local/itk/InsightToolkit-4.11.0/bin/Modules/ThirdParty/VNL/src/vxl/vcl -I/usr/local/itk/InsightToolkit-4.11.0/bin/Modules/ThirdParty/VNL/src/vxl/v3p/netlib -I/usr/local/itk/InsightToolkit-4.11.0/Modules/ThirdParty/VNL/src/vxl/core -isystem /usr/local/itk/InsightToolkit-4.11.0/Modules/ThirdParty/VNL/src/vxl/vcl -isystem /usr/local/itk/InsightToolkit-4.11.0/Modules/ThirdParty/VNL/src/vxl/v3p/netlib -I/usr/local/itk/InsightToolkit-4.11.0/Modules/ThirdParty/VNLInstantiation/include -I/usr/local/itk/InsightToolkit-4.11.0/bin/Modules/ThirdParty/KWSys/src -I/usr/local/itk/InsightToolkit-4.11.0/Modules/ThirdParty/KWIML/src -I/usr/local/itk/InsightToolkit-4.11.0/bin/Modules/ThirdParty/KWIML/src -I/usr/local/itk/InsightToolkit-4.11.0/Modules/Core/Common/include -I/usr/local/itk/InsightToolkit-4.11.0/bin/Modules/Core/Common -I/usr/local/itk/InsightToolkit-4.11.0/Modules/Core/FiniteDifference/include -I/usr/local/itk/InsightToolkit-4.11.0/Modules/Filtering/CurvatureFlow/include -I/usr/local/itk/InsightToolkit-4.11.0/Modules/Filtering/AnisotropicSmoothing/include -I/home/yan/cs9535project/MattesMutualInformation/MattesMutualInformation/./common/inc -I/usr/local/cuda-8.0/include -isystem /usr/local/itk/InsightToolkit-4.11.0/Modules/ThirdParty/VNL/src/vxl/core/vnl/algo -isystem /usr/local/itk/InsightToolkit-4.11.0/Modules/ThirdParty/VNL/src/vxl/core/vnl -isystem /usr/local/itk/InsightToolkit-4.11.0/bin/Modules/ThirdParty/HDF5/src/itkhdf5/c++/src -isystem /usr/local/itk/InsightToolkit-4.11.0/Modules/ThirdParty/HDF5/src/itkhdf5/c++/src -isystem /usr/local/itk/InsightToolkit-4.11.0/bin/Modules/ThirdParty/HDF5/src/itkhdf5/src -isystem /usr/local/itk/InsightToolkit-4.11.0/Modules/ThirdParty/HDF5/src/itkhdf5/src 

