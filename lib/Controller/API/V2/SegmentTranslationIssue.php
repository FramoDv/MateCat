<?php
namespace API\V2  ;
use API\V2\Json\SegmentTranslationIssue as JsonFormatter;
use LQA\EntryDao as EntryDao ;

class SegmentTranslationIssue extends ProtectedKleinController {

    private $chunk ;
    private $project ;
    private $validator ;
    private $segment ;
    private $translation ;
    private $issue ;

    protected function afterConstruct() {
        $this->validator = new JobPasswordValidator(
            $this->request->id_job,
            $this->request->password
        );
    }

    private function prepareData() {
        // Ensure chunk is in project
        $dao = new \Segments_SegmentDao( \Database::obtain() );

        $this->segment = $dao->getByChunkIdAndSegmentId(
            $this->request->id_job,
            $this->request->password,
            $this->request->id_segment
        );

        $this->chunk = \Chunks_ChunkDao::getByIdAndPassword(
            $this->request->id_job,
            $this->request->password
        );

        $this->project = \Projects_ProjectDao::findById(
            $this->chunk->id_project
        );

    }

    private function validateCategoryId() {
        $this->qa_model = \LQA\ModelDao::findById( $this->project->id_qa_model );
        $this->category = \LQA\CategoryDao::findById( $this->request->id_category );
        if ( $this->category->id_model != $this->qa_model->id ) {
            throw new ValidationError('QA model id mismatch');
        }
    }

    private function validate() {
        $this->prepareData() ;

        if ( $this->request->id_category ) {
            $this->validateCategoryId();
        }

        // TODO: extend validations here, for instance check the
        // project has a QA model.

        if ( !$this->segment ) {
            throw new NotFoundError();
        }

        $this->translation = $this->segment->findTranslation( $this->request->id_job ) ;

        if ( !$this->translation ) {
            throw new NotFoundError();
        }

        // IF an issue_id is provided check it's in the segment scope
        if ( $this->request->id_issue ) {
            $this->issue = \LQA\EntryDao::findById( $this->request->id_issue );

            if ( !$this->issue ) {
                throw new ValidationError('issue not found');
            }

            if ( $this->issue->id_segment != $this->segment->id ) {
                throw new ValidationError('issue not in segment scope');
            }
        }

        return true;
    }

    protected function validateRequest() {
        if ( !($this->validate() ) ) {
            $this->response->code(404);
            $this->response->json( array('error' => 'Not found') );
        }
    }

    public function index() {
        \Log::doLog("version number: ". $this->getVersionNumber());
        $result = \LQA\EntryDao::findAllByTranslationVersion(
            $this->translation->id_segment,
            $this->translation->id_job,
            $this->getVersionNumber()
        );

        $json = new JsonFormatter( );
        $rendered = $json->renderArray( $result );

        $this->response->json( array('issues' => $rendered) );
    }

    public function create() {
        $data = array(
            // 'uid'                 => null,
            'id_segment'          => $this->request->id_segment,
            'id_job'              => $this->request->id_job,
            'id_category'         => $this->request->id_category,
            'severity'            => $this->request->severity,
            'translation_version' => $this->translation->version_number,
            'target_text'         => $this->request->target_text,
            'start_node'          => $this->request->start_node,
            'start_offset'        => $this->request->start_offset,
            'end_node'            => $this->request->end_node,
            'end_offset'          => $this->request->end_offset,
            'is_full_segment'     => false,
            'penalty_points'      => $this->getPenaltyPoints(),
            'comment'             => $this->request->comment
        );

        $result = \LQA\EntryDao::createEntry( $data );
        $json = new JsonFormatter( );
        $rendered = $json->renderItem( $result );

        $this->response->json( array('issue' => $rendered) );
    }

    public function delete() {
        $this->validateAdditionalPassword();
        EntryDao::deleteEntry( $this->issue );
        $this->response->code(200);
    }

    private function getVersionNumber() {
        \Log::doLog($this->request->params());

        if ( null !== $this->request->param('version_number') ) {
            return $this->request->param('version_number') ;
        }
        else {
            return $this->translation->version_number ;
        }
    }

    private function validateAdditionalPassword() {
        // TODO: check password is good for deletion
    }

    private function getPenaltyPoints() {
        $severities = $this->category->getJsonSeverities() ;
        foreach($severities as $severity) {
            if ( $severity['label'] == $this->request->severity ) {
                return $severity['penalty'];
            }
        }
        throw new \Exception('Provided severity was not found in model');
    }

}