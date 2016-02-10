    /* Tijmen Verhulsdonck 376822, */
    /* Ahmed elmeleh 377487, */
    /* Benjamin Ezepue 376612,*/
    /* Enrique Ortiz Pasamontes 376637 */

// STL 
#include <map>
#include <vector>
#include <utility>

// LLVM 
#include <llvm/Pass.h>
#include <llvm/IR/LLVMContext.h>
#include <llvm/IR/Function.h>
#include <llvm/IR/Instruction.h>
#include <llvm/IR/Instructions.h>
#include "llvm/Support/CFG.h"
#include <llvm/Support/raw_ostream.h>
#include <llvm/Support/InstIterator.h>
#include <llvm/IR/Constants.h>

    using namespace llvm;

    namespace {


    class DefinitionPass  : public FunctionPass {
    public:
        struct VarInfo {
           bool isInitialized;
           bool isNotified;
        };
        static const bool verbose = false;

        static char ID;
        DefinitionPass() : FunctionPass(ID) {}

        virtual void getAnalysisUsage(AnalysisUsage &au) const {
            au.setPreservesAll();
        }

        virtual bool runOnFunction(Function &F) {
            std::map <std::string, VarInfo> varInitMap;
            for(BasicBlock &b : F.getBasicBlockList()){ //for each block found in function
                for (BasicBlock::iterator ii = b.begin(), ie = b.end(); ii != ie; ++ii) {  //Iterate over the instructions of each block
                      if (AllocaInst *ai = dyn_cast<AllocaInst>(&*ii)) { //If instruction is an allocation
                          if(ai->hasName()) //And it has a name
                          {
                              VarInfo newvar;
                              newvar.isInitialized = false;
                              newvar.isNotified = false;
                                    varInitMap[ai->getName().str()] = newvar;
                              if(verbose)
                                  errs() << ai->getName()<< " allocated\n";//TODO
                          }
                    }
                    if(verbose){
                        if (CallInst *ci = dyn_cast<CallInst>(&*ii)) {
                                errs()<< ci->getCalledFunction()->getName()<<" function\n";
                        }
                    }
                    if (StoreInst *si = dyn_cast<StoreInst>(&*ii)) {
                        if (si->getOperand(1)->hasName())
                        {
                              varInitMap[si->getOperand(1)->getName().str()].isInitialized = true;
                            if(verbose)
                                errs() << si->getOperand(1)->getName()<< " initialized\n";
                        }
                    }

                    if (LoadInst *li = dyn_cast<LoadInst>(&*ii)) {
                        std::string varName = li->getOperand(0)->getName().str();
                        if(verbose)
                        {
                            errs() << "  Load Instruction: " << li->getOperand(0)->getName() << ".    initialization state:  " << varInitMap[varName].isInitialized<<"\n";
                        }
                        if (li->getOperand(0)->hasName() && varInitMap[varName].isInitialized == false && varInitMap[varName].isNotified == false)
                        {
                            errs() <<varName<<"\n";
                            varInitMap[varName].isNotified = true;
                        }
                    }
                }

            }

            //Print all maps values
            if(verbose)
            {
                if (verbose) errs() << "new Block:\n";
                std::map<std::string, VarInfo>::iterator variablesMapIterator = varInitMap.begin();
                while (variablesMapIterator!=varInitMap.end())
                {
                    errs()<<"  Iterator: " << variablesMapIterator->first << "\n";
                    errs()<<"    isInitialized: " << variablesMapIterator->second.isInitialized << "\n";
                    errs()<<"    isNotified: " << variablesMapIterator->second.isNotified << "\n";
                    variablesMapIterator++;
                }
            }
        }
    };

    class FixingPass : public FunctionPass {
    public:
        static char ID;
        FixingPass() : FunctionPass(ID){}
        struct VarInfo {
           bool isInitialized;
           bool isNotified;
             AllocaInst *Ais;
           std::string InitAns = "No";
           std::string varType;
        };
        static const bool verbose = false;

        virtual bool runOnFunction(Function &F){
            std::map <std::string, VarInfo> varInitMap;
            for(BasicBlock &b : F.getBasicBlockList()){ //for each block found in function
            	if(verbose) errs() << "\nNewBlock:\n";
                for (BasicBlock::iterator ii = b.begin(), ie = b.end(); ii != ie; ++ii) {  //Iterate over the instructions of each block
                    if (AllocaInst *ai = dyn_cast<AllocaInst>(&*ii))
                    { //If instruction is an allocation
                        if(ai->hasName()) //And it has a name
                        {
                            VarInfo newvar;
                            newvar.isInitialized = false;
                            newvar.isNotified = false;
                            newvar.Ais = ai;
                             std::string VarName = ai->getName().str();
                             varInitMap[VarName] = newvar;
                            if(varInitMap[VarName].Ais->getAllocatedType()->isDoubleTy())
                            {
                                varInitMap[VarName].varType = "Double";
                            }
                            else if(varInitMap[VarName].Ais->getAllocatedType()->isFloatTy())
                            {
                                varInitMap[VarName].varType = "Float";
                            }
                            else if(varInitMap[VarName].Ais->getAllocatedType()->isIntegerTy())
                            {
                                varInitMap[VarName].varType = "Integer";
                            }


                            if(verbose)
                                errs() << "  allocated Variable "<<VarName<< "\n";
                        }
                    }
                if (CallInst *ci = dyn_cast<CallInst>(&*ii)) {
                       if(verbose) errs()<<"  Call Function : " <<ci->getCalledFunction()->getName()<<" \n";
                }
                if (StoreInst *si = dyn_cast<StoreInst>(&*ii)) {
                    if (si->getOperand(1)->hasName())
                    {
                        varInitMap[si->getOperand(1)->getName().str()].isInitialized = true;
                        varInitMap[si->getOperand(1)->getName().str()].InitAns = "YES";
                        if(verbose)
                            errs() <<"  Variable "<< si->getOperand(1)->getName()<< " : has been initialized\n";
                    }
                }
                if (LoadInst *li = dyn_cast<LoadInst>(&*ii))
                {
                    if (li->getOperand(0)->hasName())
                    {
                        std::string varName = li->getOperand(0)->getName().str();

                        if(verbose)
                        {
                            errs() << "  Load Instruction: " << varName << ". Is it initialized? " << varInitMap[varName].InitAns <<"\n    Variable type = "<<varInitMap[varName].varType <<"\n";
                        }
                        //If we are trying to load an uninitialized variable, we initialize it just after the allocation instruction.
                        if( varInitMap[varName].isInitialized == false && varInitMap[varName].isNotified == false)
                        {
                            if(!verbose) errs() <<varName<<"\n";
                            varInitMap[varName].isNotified = true;
                            if (varInitMap[varName].varType == "Double")
                            {
                                double d_init = 30.0;
                                if(verbose) errs()<< "    Initializing var "<< varName <<".  value =" << d_init<<"\n";
                                Value *num = ConstantFP::get(Type::getDoubleTy(b.getContext()), d_init);
                                StoreInst *my_store = new StoreInst(num,varInitMap[varName].Ais);
                                my_store->insertAfter(varInitMap[varName].Ais);

                            }
                            else if (varInitMap[varName].varType == "Float")
                            {
                                float f_init = 20.0;
                                if(verbose) errs()<< "    Initializing var "<< varName <<".  value =" <<  f_init<<"\n";
                                Value *num = ConstantFP::get(Type::getFloatTy(b.getContext()), f_init);
                                StoreInst *my_store = new StoreInst(num,varInitMap[varName].Ais);
                                my_store->insertAfter(varInitMap[varName].Ais);
                            }
                            else if (varInitMap[varName].varType == "Integer")
                            {
                                int i_init = 10 ;
                                if(verbose) errs()<< "    Initializing var "<< varName <<".  value =" <<  i_init<<"\n";
                                Value *num = ConstantInt::get(Type::getInt32Ty(b.getContext()), i_init);
                                StoreInst *my_store = new StoreInst(num,varInitMap[varName].Ais);
                                my_store->insertAfter(varInitMap[varName].Ais);
                            }
                            else
                            {
                                errs() << " unknown type";
                            }

                        }
                    }
                }
            }

        }

        //Print all maps values
        if(verbose)
        {
            errs() << "Block list:\n";
            std::map<std::string, VarInfo>::iterator variablesMapIterator = varInitMap.begin();
            if(variablesMapIterator==varInitMap.end()) errs() << "    Empty list.\n";
            while (variablesMapIterator!=varInitMap.end())
            {
                errs()<<"  Iterator: " << variablesMapIterator->first << "\n";
                errs()<<"    isInitialized: " << variablesMapIterator->second.isInitialized << "\n";
                errs()<<"    isNotified: " << variablesMapIterator->second.isNotified << "\n";
                variablesMapIterator++;
            }
        }
        return true;
    }
};
} // namespace


    char DefinitionPass::ID = 0;
    char FixingPass::ID = 1;

    // Pass registrations
    static RegisterPass<DefinitionPass> X("def-pass", "Reaching definitions pass");
    static RegisterPass<FixingPass> Y("fix-pass", "Fixing initialization pass");
